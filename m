Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbXE3MSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbXE3MSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 08:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXE3MSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 08:18:30 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:53985 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbXE3MS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 08:18:29 -0400
X-Originating-Ip: 72.143.65.211
Date: Wed, 30 May 2007 08:17:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: should "create_proc_read_entry" enforce read-only semantics?
Message-ID: <Pine.LNX.4.64.0705300813150.13465@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  admittedly more nitpickery, but it strikes me as a bit confusing
that you can use create_proc_read_entry() to create writable proc
files, since that routine is simply a wrapper for create_proc_entry
that passes the mode untouched and unexamined.

  that's why you can get stuff like this from drivers/scsi/scsi_proc.c

...
        p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
                        sht->proc_dir, proc_scsi_read, shost);
        if (!p) {
                printk(KERN_ERR "%s: Failed to register host %d in"
                       "%s\n", __FUNCTION__, shost->host_no,
                       sht->proc_name);
                return;
        }

        p->write_proc = proc_scsi_write_proc;
...

  it just seems to abuse the semantics to use a routine called
"create_proc_read_entry" to create a writable file.  but that's just
me.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

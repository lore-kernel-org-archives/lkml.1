Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbXIRMae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbXIRMae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 08:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbXIRMa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 08:30:27 -0400
Received: from herkules.vianova.fi ([194.100.28.129]:49834 "HELO
	mail.vianova.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755933AbXIRMa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 08:30:26 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 08:30:26 EDT
Date: Tue, 18 Sep 2007 15:23:14 +0300
From: Ville Herva <v@iki.fi>
To: linux-kernel@vger.kernel.org
Subject: 2.4.35 SMP: ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal
Message-ID: <20070918122314.GL29062@vianova.fi>
Reply-To: v@iki.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux herkules.vianova.fi 2.4.35
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

I got a bunch of these into dmesg:

EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory #323880: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory #323888: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
EXT3-fs error (device sd(8,2)): ext3_readdir: bad entry in directory #323882: rec_len is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0

The kernel is 2.4.35 SMP, dual-processor. The scsi driver is Fusion MPT SCSI
Host driver 2.05.16.

The device is /dev/sda2, root fs.

One line per each directory had dropped into dmesg each night (I think
during updatedb) before I noticed.

The directories in question have not been written to for ages:

>debugfs /dev/sda2
debugfs:  ncheck 323888
Inode   Pathname
323888  /usr/share/doc/logcheck-1.1.1
debugfs:  ncheck 323882
Inode   Pathname
323882  /usr/share/doc/dev86-0.15.5
debugfs:  ncheck 323880
Inode   Pathname
323880  /usr/share/doc/mod_put-1.3


The hardware _should_ be solid, although I can never 100% sure rule out disk
level corruption.

Does this ring any bells to anyone, short of block level corruption?



-- v -- 

v@iki.fi


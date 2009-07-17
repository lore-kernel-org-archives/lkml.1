Return-Path: <linux-kernel-owner+w=401wt.eu-S934653AbZGQNrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934653AbZGQNrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934589AbZGQNrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:47:06 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:44756 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941AbZGQNrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:47:06 -0400
Date: Fri, 17 Jul 2009 09:44:38 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: what is "temporary" about code in "__register_chrdev_region()"?
Message-ID: <alpine.LFD.2.00.0907170941360.4333@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  i was just perusing the code for that routine in fs/char_dev.c and
noticed the label that some of that code was, well, temporary:

        /* temporary */     [line 99]
        if (major == 0) {
                for (i = ARRAY_SIZE(chrdevs)-1; i > 0; i--) {
                        if (chrdevs[i] == NULL)
                                break;
                }

                if (i == 0) {
                        ret = -EBUSY;
                        goto out;
                }
                major = i;
                ret = major;
        }

  so what's "temporary" about it?  that it can (dynamically) handle a
major number of zero?  is that supposed to represent a first step in
migrating to alloc_chrdev_region(), or what?  i'm just curious,

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
"Kernel Newbie Corner" column @ linux.com:          http://cli.gs/WG6WYX
========================================================================

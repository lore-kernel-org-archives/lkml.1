Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbXEXRai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbXEXRai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbXEXRaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:30:19 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:44074 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbXEXRaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:30:17 -0400
Date: Thu, 24 May 2007 19:29:29 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>
cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
In-Reply-To: <4655C93D.40005@gmx.de>
Message-ID: <Pine.LNX.4.61.0705241927410.31549@yvahk01.tjqt.qr>
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de>
 <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc>
 <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr> <46536C0F.50101@imap.cc>
 <4655676A.1000102@gmx.de> <4655C554.7030000@imap.cc> <4655C93D.40005@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 24 2007 19:19, Lars K.W. Gohlke wrote:
> I want to read from serial port (I mean the port, which is called
> /dev/ttyS0 in user-space). Then I want copy_to_user() it through
> /proc/serialPort
>
> This is just to get familiar with driver programming (in kernelspace),
> it could be better done in userspace - I know. But this is for learning.
>
> It is a kind of synthetic problem, but after this, I hope too know how
> to handle further ones.
>
> Understood? It is a little bit strange, but hope it is explained well. ;)
>
> If tell me that for /dev/ttyS0 I can adept it to /dev/ttyS1 etc..


struct file *filp = filp_open("/dev/ttyS0");
char buf[4096];
mm_segment_t oldfs = get_fs();
loff_t pos = 0;

set_ds(KERNEL_DS);
while (vfs_read(filp, buf, sizeof(buf), &pos) > 0)
	printk("%s\n", buf);

filp_close(filp);



[I've warned about it... ;-) ]

	Jan
-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbXD2MSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbXD2MSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbXD2MSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:18:30 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:45122 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439AbXD2MSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:18:14 -0400
Date: Sun, 29 Apr 2007 14:09:00 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hans-J?rgen Koch <hjk@linutronix.de>, Bill Davidsen <davidsen@tmr.com>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: Re: [GIT PATCH] UIO patches for 2.6.21
In-Reply-To: <1177835453.5791.7.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0704291403080.506@yvahk01.tjqt.qr>
References: <20070427224957.GA17967@kroah.com> <4633A6D7.3030806@tmr.com> 
 <200704282203.31141.hjk@linutronix.de>  <20070428211515.4e9fd8c5@the-village.bc.nu>
  <1177792297.7646.297.camel@localhost.localdomain>  <20070429012338.GA11147@suse.de>
 <1177835453.5791.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 29 2007 10:30, Thomas Gleixner wrote:
>> 
>> Unless you think we should also use the same "taint" flag on those
>> accesses too, and if so, I have no objection.
>
>Right, this is just a hint, that something in user space is accessing
>the hardware directly. Not a too bad idea, but pretty much useless when
>we add X to the picture as it will be set always :)

Index: linux-2.6.21-mm_20040728/drivers/char/mem.c
===================================================================
--- linux-2.6.21-mm_20040728.orig/drivers/char/mem.c
+++ linux-2.6.21-mm_20040728/drivers/char/mem.c
@@ -274,6 +274,9 @@ static int mmap_mem(struct file * file, 
 	if (!private_mapping_ok(vma))
 		return -ENOSYS;
 
+	if (strcmp(current->comm, "Xorg") != 0)
+		tainted |= TAINT_USER;
+
 	vma->vm_page_prot = phys_mem_access_prot(file, vma->vm_pgoff,
 						 size,
 						 vma->vm_page_prot);
#<EOF>


Jan
-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbXL3Vek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbXL3Vek (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbXL3Ved
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:34:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:56839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466AbXL3Ved (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:34:33 -0500
Date: Sun, 30 Dec 2007 22:32:12 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
In-Reply-To: <20071230210007.GA3136@elte.hu>
Message-ID: <alpine.LSU.0.999.0712302230370.15232@be1.lrz>
References: <9FXbU-3M4-11@gated-at.bofh.it> <9G2Om-4hg-1@gated-at.bofh.it>
 <9G7O3-3O2-7@gated-at.bofh.it> <9G8qN-4TX-13@gated-at.bofh.it>
 <E1J92JB-00013N-P3@be1.7eggert.dyndns.org> <20071230181004.GA21968@elte.hu>
 <477805F1.4070201@zytor.com> <20071230210007.GA3136@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/Mc0JAfsjRz6c8IpMRn2J0WgBEiXglnx+N5TA
 umT/1cMhk131JNMLm93qS8K+EodCoLH6eiCxOpASFdHNo625B3
 jYVF97ri4q+3d7RH9Ymiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2007, Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> > Ingo Molnar wrote:
> >> * Bodo Eggert <7eggert@gmx.de> wrote:

> >>> BTW: The error function in linux-2.6.23/arch/i386/boot/compressed/misc.c 
> >>> uses while(1) without cpu_relax() in order to halt the machine. Is this 
> >>> fixed? Should it be fixed?
> >>
> >> this is early bootup so there's no need to be "nice" to other cores or 
> >> sockets - none of them are really running.
> >>
> >
> > It probably should actually HLT, to avoid sucking power, and stressing 
> > the thermal system.  We're dead at this point, and the early 486's 
> > which had problems with HLT will lock up - we don't care.
> 
> ok. Like the patch below?

>  
> -	while(1);	/* Halt */
> +	asm("cli; hlt");	/* Halt */

The other users would loop around the hlt. Cargo Cult?
-- 
Top 100 things you don't want the sysadmin to say:
97. Go get your backup tape. (You _do_ have a backup tape?)

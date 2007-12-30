Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbXL3RLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbXL3RLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 12:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXL3RLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 12:11:10 -0500
Received: from bender.weihenstephan.org ([62.245.246.226]:50203 "EHLO
	bender.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbXL3RLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:11:09 -0500
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Date: Sun, 30 Dec 2007 18:10:58 +0100
User-Agent: KMail/1.9.4
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
References: <477711DC.5030800@keyaccess.nl> <20071230152835.GX16946@elte.hu> <20071230153818.1a554a7e@the-village.bc.nu>
In-Reply-To: <20071230153818.1a554a7e@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712301810.59790.juergen127@kreuzholzen.de>
X-CTCH-RefID: str=0001.0A0B0201.4777D127.0174,ss=1,fgs=0
X-cff-SpamScore: 0(/)
X-cff-SpamReport: ----- ----- Message is unknown to the spam scanner.
X-cff-LastScanner: pcre
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 December 2007 16:38, Alan Cox wrote:
> > do you have any memories about the outb_p() use of misc_32.c:
> >
> >         pos = (x + cols * y) * 2;       /* Update cursor position */
> >         outb_p(14, vidport);
> >         outb_p(0xff & (pos >> 9), vidport+1);
> >         outb_p(15, vidport);
> >         outb_p(0xff & (pos >> 1), vidport+1);
> >
> > was this ever needed? This is so early in the bootup that can we cannot
>
> None - but we don't care.

Was this embedded outb to 0x80 for delay only? Maybe I'm wrong. But in the 
case above it forces the chipselect signal to deselect the hardware between 
the access to vidport and vidport+1. Some devices need this to latch the 
values correctly. Otherwise the chipselect signal would be active for all 
four accesses in the example above (and only data and addresses are changing 
from device's view).

Juergen

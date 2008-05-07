Return-Path: <linux-kernel-owner+w=401wt.eu-S932658AbYEGWOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbYEGWOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbYEGWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:13:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:55150 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640AbYEGWNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:13:47 -0400
Date: Thu, 8 May 2008 00:14:35 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: 2.6.26, PAT and AMD family 6
Message-ID: <20080507221435.GH18516@elf.ucw.cz>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <20080507212343.GB14951@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > This feature and detection code is hard to clean up and definitely out
> > > of the scope of this patch.
> > 
> > Did you even look at the commit we are discussing?
> > 
> > It ***adds*** exactly the same code at three different places.
> 
> Yes, I did. And it adds it for a fscking good reason. 
> 
> 1) two times in common.c due to the existing detection logic mess
> 2) once in the 64 bit version

WTF? The code can happily live in a function. No need to add two
copies to single file. If you need to share function between 32 and 64
bit, just put it to separate .c file.

> > fall into his own trap by patching only one copy of his duplicated code.
> 
> That's not a real good reason to yell at him.

Actually no, that's not a good reason to yell at _him_. But it is
_perfectly valid_ reason to yell at whoever commited that to x86 tree,
given that:

1) it has empty changelog (come on, "review" a patch and not notice
that changelog is empty?!) 

2) HPA said it was bad idea

3) copy&paste code remained in the patch 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

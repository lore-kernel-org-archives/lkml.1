Return-Path: <linux-kernel-owner+w=401wt.eu-S932602AbYBABFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbYBABFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934961AbYBABE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:04:58 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46514 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935009AbYBABE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:04:57 -0500
Date: Fri, 1 Feb 2008 02:05:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kill misleading comments in trampoline_*.S
Message-ID: <20080201010509.GB5112@elf.ucw.cz>
References: <20080201005429.GA5085@elf.ucw.cz> <86802c440801311702i1ac94b0m2af0bcdec6c9e866@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440801311702i1ac94b0m2af0bcdec6c9e866@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-01-31 17:02:29, Yinghai Lu wrote:
> On Jan 31, 2008 4:54 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >
> >
> > Both trampolines actually *do* set up stack. (Is the "we jump into
> > compressed/head.S" comment still true?)
> >
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> >
> > diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
> > index 9bcc1c6..5398547 100644
> > --- a/arch/x86/kernel/trampoline_32.S
> > +++ b/arch/x86/kernel/trampoline_32.S
> > @@ -11,9 +11,6 @@
> >   *     trampoline page to make our stack and everything else
> >   *     is a mystery.
> >   *
> > - *     In fact we don't actually need a stack so we don't
> > - *     set one up.
> > - *
> >   *     We jump into the boot/compressed/head.S code. So you'd
> >   *     better be running a compressed kernel image or you
> >   *     won't get very far.
> 
> should be arch/x86/kernel/head_32.S

Thanks, fixed in my local copy. But that's separate problem. ;-).

								Pavel

diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
index 9bcc1c6..6458067 100644
--- a/arch/x86/kernel/trampoline_32.S
+++ b/arch/x86/kernel/trampoline_32.S
@@ -11,12 +11,7 @@
  *	trampoline page to make our stack and everything else
  *	is a mystery.
  *
- *	In fact we don't actually need a stack so we don't
- *	set one up.
- *
- *	We jump into the boot/compressed/head.S code. So you'd
- *	better be running a compressed kernel image or you
- *	won't get very far.
+ *	We jump into arch/x86/kernel/head_32.S.
  *
  *	On entry to trampoline_data, the processor is in real mode
  *	with 16-bit addressing and 16-bit data.  CS has some value
diff --git a/arch/x86/kernel/trampoline_64.S b/arch/x86/kernel/trampoline_64.S
index e30b67c..4aedd0b 100644
--- a/arch/x86/kernel/trampoline_64.S
+++ b/arch/x86/kernel/trampoline_64.S
@@ -10,9 +10,6 @@
  *	trampoline page to make our stack and everything else
  *	is a mystery.
  *
- *	In fact we don't actually need a stack so we don't
- *	set one up.
- *
  *	On entry to trampoline_data, the processor is in real mode
  *	with 16-bit addressing and 16-bit data.  CS has some value
  *	and IP is zero.  Thus, data addresses need to be absolute


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

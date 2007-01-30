Return-Path: <linux-kernel-owner+w=401wt.eu-S965308AbXA3QA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965308AbXA3QA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965507AbXA3QA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:00:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39417 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965308AbXA3QA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:00:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
Date: Tue, 30 Jan 2007 17:01:40 +0100
User-Agent: KMail/1.9.1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org> <200701300357.34304.lenb@kernel.org>
In-Reply-To: <200701300357.34304.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701301701.41079.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, 30 January 2007 09:57, Len Brown wrote:
> On Monday 29 January 2007 19:12, Linus Torvalds wrote:
> > 
> > On Mon, 29 Jan 2007, Stephen Hemminger wrote:
> > > 
> > > Why do you insist on maintaining the wrong initialization order
> > > on resume? When I raised the issue, Len brought up that the resume
> > > order did not match spec, but then there has been slow progress
> > > in fixing it (it's buried in -mm tree).
> > 
> > It's not getting merged, SINCE IT DOESN'T WORK. It causes all sorts of 
> > problems, because ACPI requires all kinds of things to be up and running 
> > in order to actually work, and that in turn breaks all the devices that 
> > have different ordering constraints.
> > 
> > ACPI is a piece of sh*t. It asks the OS to do impossible things, like 
> > running it early in the config sequence when it then at the same time 
> > wants to depend on stuff that are there *late* in the sequence. It's not 
> > the first time this insane situation has happened, either.
> 
> And it will not be the last:-)
> 
> There are really two cases, one is easy, one hard:
> 
> 1. The ACPI spec and our knowledge of how the HW and talking to our own BIOS
>     folks tells us quite a bit about how things are supposed to work.
> 
> 2. "Windows Bug Compatibility" (tm)
>     When OEMs build systems and test them only with Windows, then
>     the implementation quirks of Windows get ingrained in the platforms.
>     Linux then tries to run on the same platform and wonders why
>     the BIOS does "unusual" things.  The answer is because it has been
>     only tested on Windows and BIOS quirks slip through Windows testing.
> 
>     To be fair, the exact same thing would happen in reverse to Windows
>     if vendors only tested with Linux.
> 
>     http://www.linuxfirmwarekit.org/ is intended to help mitigate some of this
>     problem.  So at least vendors that care about Linux can make sure that
>     they minimize the curve balls they throw us.
> 
> An example of a recent curve ball is when the BIOS supplies two APIC (MADT)
> tables.  Well, the spec says there should be only one...  We have proof
> that Windows doesn't use the 1st for enumerating processors because
> Windows works on a box with a garbled 1st table.
> If we prove that Windows doesn't use the second either then it means
> they enumerate processors  via the DSDT -- which means bringing up
> the ACPI interpreter before bringing up SMP -- and that would require
> a significant change to Linux boot sequence...
> 
> > But we'll try to merge the patch that totally switches around the whole 
> > initialization order hopefully early after 2.6.20. But no way in hell do 
> > we do it now, and I personally suspect we'll end reverting it when we do 
> > try it just because it will probably break other things. But we'll see.
> 
> I agree with this plan, and I concur with your outlook.
> 
> I think Rafel is holding the ball here as we wait for an SMP-safe freezer:
> http://lists.osdl.org/pipermail/linux-pm/2006-December/004233.html

Well, no longer. :-)

The freezer in 2.6.20-rc6 should be SMP-safe and the patches to change
the suspend-resume code ordering are in -mm:

pm-change-code-ordering-in-mainc.patch
swsusp-change-code-ordering-in-diskc.patch
swsusp-change-code-order-in-diskc-fix.patch
swsusp-change-code-ordering-in-userc.patch
swsusp-change-code-ordering-in-userc-sanity.patch
swsusp-change-pm_ops-handling-by-userland-interface.patch

I have no problems whatsoever with these patches on SMP boxes and if anyone
has, please let me know.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

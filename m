Return-Path: <linux-kernel-owner+w=401wt.eu-S1759976AbZBXUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbZBXUAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZBXUA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:00:29 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:47276 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbZBXUA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:00:28 -0500
From: Philippe Grenard <philippe.grenard@laposte.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel (amd64)
Date: Tue, 24 Feb 2009 21:00:51 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-acpi2-phiphi; KDE/4.2.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       John Stoffel <john@stoffel.org>
References: <200902131944.56634.philippe.grenard@laposte.net> <200902211121.46292.philippe.grenard@laposte.net> <49A0C693.6000407@zytor.com>
In-Reply-To: <49A0C693.6000407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902242100.51410.philippe.grenard@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 February 2009 04:29:23 H. Peter Anvin wrote:
> Philippe Grenard wrote:
> > On Friday 20 February 2009 22:58:30 Ingo Molnar wrote:
> >> * Philippe Grenard <philippe.grenard@laposte.net> wrote:
> >>> dc1e35c6e95e8923cf1d3510438b63c600fee1e2 is first bad commit
> >>> commit dc1e35c6e95e8923cf1d3510438b63c600fee1e2
> >>> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> >>> Date:   Tue Jul 29 10:29:19 2008 -0700
> >>>
> >>>     x86, xsave: enable xsave/xrstor on cpus with xsave support
> >>
> >> [...]
> >>
> >>> A bit of googling gave me this :
> >>> http://lkml.org/lkml/2009/1/19/161
> >>> which exactly corresponds to my problem with 2.6.28 !
> >>>
> >>> A "solution" proposed was to try to check the bios setting
> >>> "cpuid value limit" and disable it if enabled. This did help
> >>> me to boot 2.6.28 or previously failing kernel compiled during
> >>> git-bisect, but gave me the "random freeze" any way....
> >>
> >> Note that the workaround for that BIOS bug is already in the
> >> latest upstream kernel, i.e. in 2.6.29-rc5.
> >>
> >> Could you please try -rc5, whether it works out of box?
> >>
> >> If you still see freezes, could you try the "nofxsr" boot
> >> option? That will turn off the new FPU code both in the hw and
> >> in the kernel.
> >>
> >> 	Ingo
> >
> > Hello Ingo, thanks for your reply,
> >
> > I've tried to boot 2.6.29-rc5 with both "Max CPUID Value" Enabled and
> > Disabled, and tried for both case the "nofxsr" option without better
> > result...
> >
> > As I said before, I use the default dsdt table : can this be a problem
> > too ?
>
> OK, this is a completely different problem then.  Any way you could do a
> "git bisect" to track down the exact place where this broke?
>
> 	-hpa

Ok, so I have news for my problem!
After trying a minimalist config file which gave me a working system, I tried to 
add some missing features such as ACPI, and so on.

I finally have reduced the problem to this : 
with 
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
as the sole difference, the kernel *without* these 2 modules will run with no 
problem at all, but when enabled, the kernel will freeze just after boot.

I would gladly try to bisect this since this works with 2.6.27.
The problem is that I had some other problem which prevented me to boot 2.6.28 
(even if this other problem has been identified now) so I would maybe need to 
patch some files to get working kernel to bisect this new ACPI problem, but 
that is far from my limited knowledge.... I would need some hints for this...

Should I maybe open a new thread for this issue? does this problem has already 
been known ?

I also use to "reply all". Please tell me if this is a bother.

Philippe



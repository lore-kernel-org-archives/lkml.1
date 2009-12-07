Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZLGPtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZLGPtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZLGPtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:49:14 -0500
Received: from www.tglx.de ([62.245.132.106]:33306 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbZLGPtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:49:13 -0500
Date: Mon, 7 Dec 2009 16:48:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix bogus warning in
 apic_noop.apic_write()
In-Reply-To: <20091207150425.GA5489@lenovo>
Message-ID: <alpine.LFD.2.00.0912071629350.3089@localhost.localdomain>
References: <alpine.LFD.2.00.0912071255420.3089@localhost.localdomain> <tip-a946d8f11f0da9cfc714248036fcfd3a794d1e27@git.kernel.org> <20091207150425.GA5489@lenovo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Cyrill Gorcunov wrote:
> On Mon, Dec 07, 2009 at 12:18:37PM +0000, tip-bot for Thomas Gleixner wrote:
> > Commit-ID:  a946d8f11f0da9cfc714248036fcfd3a794d1e27
> > Gitweb:     http://git.kernel.org/tip/a946d8f11f0da9cfc714248036fcfd3a794d1e27
> > Author:     Thomas Gleixner <tglx@linutronix.de>
> > AuthorDate: Mon, 7 Dec 2009 12:59:46 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 7 Dec 2009 13:16:37 +0100
> > 
> > x86: Fix bogus warning in apic_noop.apic_write()
> > 
> > apic_noop is used to provide dummy apic functions. It's installed
> > when the CPU has no APIC or when the APIC is disabled on the kernel
> > command line.
> > 
> > The apic_noop implementation of apic_write() warns when the CPU has
> > an APIC or when the APIC is not disabled.
> > 
> > That's bogus. The warning should only happen when the CPU has an
> > APIC _AND_ the APIC is not disabled. apic_noop.apic_read() has the
> > correct check.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> > Cc: <stable@kernel.org> # in <= .32 this typo resides in native_apic_write_dummy()
> > LKML-Reference: <alpine.LFD.2.00.0912071255420.3089@localhost.localdomain>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/kernel/apic/apic_noop.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> ...
> 
> Hi Thomas, Ingo,
> 
> please do not change it. There are still machines without
> cpu_has_apic bit support so with this patch any attempt
> to write to 82489DX will success. So the former code has
> been using "OR" by a purpose, there is no error.

Err, your warning has the following false positive:

     cpu_has_apic == true and disable_apic == true

Which is crap, as it warns just because someone disabled the APIC on
the command line and the kernel did the right thing of installing
apic_noop.

And I have a hard time to see how this is related to 82489DX.
 
Thanks,

	tglx

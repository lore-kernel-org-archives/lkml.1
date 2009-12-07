Return-Path: <linux-kernel-owner+w=401wt.eu-S935206AbZLGPE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935206AbZLGPE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935167AbZLGPEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:04:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:28419 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598AbZLGPEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:04:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pAY9qmFRHZ1MUC7GXUHcGdnrxBA2eVjkn1uH2LoHzAPVhvOyC87JbJ74dlRbGJL/P0
         PvULUEfWYGFCdtM4ilihOYzktXEntIfVbkiMvVMpT/FA4IvPV1r7IMB6p+JPnUbdJpQW
         PrTj9dZ8naH8KoC+aGnnZrN6ZViRm1Kbyed10=
Date: Mon, 7 Dec 2009 18:04:25 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix bogus warning in
	apic_noop.apic_write()
Message-ID: <20091207150425.GA5489@lenovo>
References: <alpine.LFD.2.00.0912071255420.3089@localhost.localdomain> <tip-a946d8f11f0da9cfc714248036fcfd3a794d1e27@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-a946d8f11f0da9cfc714248036fcfd3a794d1e27@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 12:18:37PM +0000, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  a946d8f11f0da9cfc714248036fcfd3a794d1e27
> Gitweb:     http://git.kernel.org/tip/a946d8f11f0da9cfc714248036fcfd3a794d1e27
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Mon, 7 Dec 2009 12:59:46 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 7 Dec 2009 13:16:37 +0100
> 
> x86: Fix bogus warning in apic_noop.apic_write()
> 
> apic_noop is used to provide dummy apic functions. It's installed
> when the CPU has no APIC or when the APIC is disabled on the kernel
> command line.
> 
> The apic_noop implementation of apic_write() warns when the CPU has
> an APIC or when the APIC is not disabled.
> 
> That's bogus. The warning should only happen when the CPU has an
> APIC _AND_ the APIC is not disabled. apic_noop.apic_read() has the
> correct check.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: <stable@kernel.org> # in <= .32 this typo resides in native_apic_write_dummy()
> LKML-Reference: <alpine.LFD.2.00.0912071255420.3089@localhost.localdomain>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/apic/apic_noop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
...

Hi Thomas, Ingo,

please do not change it. There are still machines without
cpu_has_apic bit support so with this patch any attempt
to write to 82489DX will success. So the former code has
been using "OR" by a purpose, there is no error.

	-- Cyrill

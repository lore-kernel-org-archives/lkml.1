Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbZDTHbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbZDTHbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZDTHbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:31:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47292 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbZDTHbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:31:10 -0400
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND][PATCH -tip 3/3] x86, mce: Add new option mce=no_cmci and mce=ignore_ce
From: Andi Kleen <andi@firstfloor.org>
References: <49EBCDB0.7000505@jp.fujitsu.com>
	<49EBCF87.4090608@jp.fujitsu.com>
Date: Mon, 20 Apr 2009 09:31:08 +0200
In-Reply-To: <49EBCF87.4090608@jp.fujitsu.com> (Hidetoshi Seto's message of "Mon, 20 Apr 2009 10:27:35 +0900")
Message-ID: <87myabpyrn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:

> This patch introduces a couple of boot option for x86_64 mce.
>
> The "mce=no_cmci" boot option disables cmci feature.
> Since cmci is a new feature so having boot controls to disable
> it will be a help if the hardware is misbehaving.

Acked-by: Andi Kleen <ak@linux.intel.com>

Although I expect on Nehalem you'll get more problems without CMCI
than with due to the shared banks. Perhaps the documentation
should make that clearer.

>
> The "mce=ignore_ce" boot option disables features for corrected
> errors, i.e. polling timer and cmci.  Usually this disablement
> is not recommended, however it will be a help if there are some
> conflict with the BIOS or hardware monitoring applications etc.

Same problem as with the earlier patch.  You need a point
somewhere where the event is cleared, otherwise all hell
breaks loose.

>  static int mce_dont_init;
> +int cmci_disabled;
> +int ignore_ce;

For global variables you should use a mce_ prefix to not pollute
global name space.

> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
> index d6b72df..64c0dd9 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
> @@ -109,6 +109,9 @@ static int cmci_supported(int *banks)
>  {
>  	u64 cap;
>  
> +	if (cmci_disabled | ignore_ce)

I presume you meant || here

-Amndi

-- 
ak@linux.intel.com -- Speaking for myself only.

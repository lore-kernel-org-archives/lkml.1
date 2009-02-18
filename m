Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZBRSb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZBRSb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZBRSbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:31:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33725 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbZBRSbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:31:48 -0500
Date: Wed, 18 Feb 2009 19:31:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: davej@codemonkey.org.uk, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Change link order of x86 cpufreq modules
Message-ID: <20090218183137.GD26802@elte.hu>
References: <20090218182822.GA19902@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218182822.GA19902@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Change the link order of the cpufreq modules to ensure that they're 
> probed in the preferred order when statically linked in.
>     
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/Makefile b/arch/x86/kernel/cpu/cpufreq/Makefile
> index 560f776..509296d 100644
> --- a/arch/x86/kernel/cpu/cpufreq/Makefile
> +++ b/arch/x86/kernel/cpu/cpufreq/Makefile
> @@ -1,6 +1,11 @@
> +# Link order matters. K8 is preferred to ACPI because of firmware bugs in early
> +# K8 systems. ACPI is preferred to all other hardware-specific drivers.
> +# speedstep-* is preferred over p4-clockmod.

Nice fix! Where does this information come from? Distro module 
ordering magic? It's rather non-trivial.

(small style nit: the first line in the Makefile is overlong.)

	Ingo

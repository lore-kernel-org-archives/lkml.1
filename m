Return-Path: <linux-kernel-owner+w=401wt.eu-S1761343AbZFKANx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343AbZFKANx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 20:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZFKANn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 20:13:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55028 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbZFKANm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 20:13:42 -0400
Date: Thu, 11 Jun 2009 02:13:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: perf_counter AMD supports performance
	monitoring for K7
Message-ID: <20090611001341.GA5631@elte.hu>
References: <1244659775.4255.1.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244659775.4255.1.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> index 240ca56..5d56742 100644
> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c
> @@ -1436,6 +1436,10 @@ static int intel_pmu_init(void)
>  
>  static int amd_pmu_init(void)
>  {
> +	/* performance-monitoring supported from K7 */
> +	if (boot_cpu_data.x86 < 7)
> +		return -ENODEV;
> +
>  	x86_pmu = amd_pmu;
>  
>  	switch (boot_cpu_data.x86) {

A commit under Linux consists of three parts:

  1) the title
  2) the changlog
  3) the body

This sloppy patch of yours manages to get _all_ three wrong:

  - the title is wrong (it is incorrect)
  - the changelog is wrong (it is missing)
  - the body is wrong (it is broken - K7 != family 7)

What the heck is going on here?

	Ingo

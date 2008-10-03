Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbYJCHi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbYJCHi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 03:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYJCHit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 03:38:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48561 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbYJCHis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 03:38:48 -0400
Date: Fri, 3 Oct 2008 09:38:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
Message-ID: <20081003073835.GD4950@elte.hu>
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com> <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com> <20081003003237.04469201@werewolf.home> <86802c440810021539y6cdff33dh9df3e04eba85a9df@mail.gmail.com> <86802c440810021546r6182a0c2id3566c1eb6ab7410@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810021546r6182a0c2id3566c1eb6ab7410@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> > boundary handling may have problem...
> 
> can you try
> 
> diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
> index ef64128..70beb13 100644
> --- a/arch/x86/kernel/cpu/mtrr/main.c
> +++ b/arch/x86/kernel/cpu/mtrr/main.c
> @@ -1044,7 +1044,7 @@ second_try:
>                 hole_sizek = range0_sizek - state->range_sizek - second_sizek;
> 
>                 /* hole size should be less than half of range0 size */
> -               if (hole_sizek > (range0_sizek >> 1) &&
> +               if (hole_sizek >= (range0_sizek >> 1) &&
>                     range0_sizek >= chunk_sizek) {

applied to tip/x86/mtrr, thanks Yinghai!

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbYEGUFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbYEGUFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbYEGUFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:05:34 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:42890 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbYEGUF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:05:28 -0400
Message-ID: <48220BC1.2050701@keyaccess.nl>
Date: Wed, 07 May 2008 22:06:25 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Daniel Hazelton <dhazelton@enter.net>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <4821A7E2.6080101@keyaccess.nl> <200805071539.32594.dhazelton@enter.net>
In-Reply-To: <200805071539.32594.dhazelton@enter.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-05-08 21:39, Daniel Hazelton wrote:

> HPA asked about why they used a whitelist instead of a blacklist in [1]. The 
> answer (in [2]) was that those are the CPU's that are guaranteed to properly 
> support PAT (no known or potential errata). However in [3] Dean Gaudet 
> complained about the AMD detection code having a limit that the Intel 
> detection code did not.

And in that thread both HPA and Ingo Molnar -- two of the three x86 arch
maintainers -- agreed that a whitelist is the wrong approach, with HPA
commenting that it lead to vendor lockin. And here I am talkng to an
Intel employee about why my entire AMD CPU family was excluded.

So why is this thing now in mainline with Ingo's sign-off and not a line
of changelog to explain it?

>                      ^^^^^---- Here in Rene's patch...

Yinghai's.

> Wouldn't this be better if written the same as the Intel side, ie:
> if (c->x86 >= 0xF && (c->x86 == 6 && c->x86_model == 7))
> (or even with c->x86_model >= 7  ?)

I doubt it, given that that condition would optimize to 0 but assuming
s/&&/||/ that's still excluding my previous Duron model 4 which, as far
as I'm aware, had functional PAT as well. Nor am I myself aware of any
model 1 trouble. Really, this whitelist seems a pretty bad idea.

> [1] http://lkml.org/lkml/2008/3/25/118
> [2] http://lkml.org/lkml/2008/3/25/292
> [3] http://lkml.org/lkml/2008/3/30/37

Questions...

-- Why is this thing in with the whitelist over the objection of arch
   maintainers?
-- why is this thing in without a single line of changelog?
-- Why does this thing hide the fact that my CPU does have PAT from
   me (even though it might elect to not trust it)?

Rene.


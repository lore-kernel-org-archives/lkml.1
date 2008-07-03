Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbYGCM5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbYGCM5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYGCM5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:57:42 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:48627 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYGCM5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:57:41 -0400
Date: Thu, 3 Jul 2008 11:20:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Barry Kasindorf <barry.kasindorf@amd.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Robert Richter <robert.richter@amd.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver:
	Setup routines
Message-ID: <20080703092052.GA5548@elte.hu>
References: <20080609175030.2844.77365.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609175030.2844.77365.sendpatchset@localhost.localdomain>
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


* Barry Kasindorf <barry.kasindorf@amd.com> wrote:

> This patchset supports the new profiling hardware available in the 
> latest AMD CPUs in the oProfile driver.

Looks interesting! There are some patch logistics issues:

1) please rebase your patches ontop of -mm, which carries the oprofile 
multiplexing cleanups and enhancements already which heavily interact 
with your patchset.

2) -mm is also based on linux-next which has a few other changes in 
drivers/oprofile as well: i did a test-merge of your patches and 3/3 
interacted heavily with API changes in linux-next. Part of the problem 
was that you mixed whitespace changes into your patch which randomly 
iteracted with other stuff. Cleanups are nice and welcome, but try to 
keep them in a separate patch. (multiple patches if the situation 
requires it)

3) please Cc: the x86 maintainers too because these patches change quite 
a few things in the x86 architecture code.

also:

>  		case 0x10:
>  			model = &op_athlon_spec;
> -			cpu_type = "x86-64/family10";
> +			cpu_type = "x86-64/family10h";
> +			break;

please just keep the ABI string at "x86-64/family10" - we can live with 
this small quirk forever. The mess to remove that quirk is much larger 
than the benefit it brings (which is small to non-existent).

[ you really dont want such a small issue block your patches.]

the next one is OK:

> +		case 0x11:
> +			model = &op_athlon_spec;
> +			cpu_type = "x86-64/family11h";

as it's really 0x11.

	Ingo

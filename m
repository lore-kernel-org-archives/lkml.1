Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYJEAqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYJEAqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 20:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYJEAqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 20:46:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54581 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbYJEAqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 20:46:38 -0400
Message-ID: <48E80E60.8080106@zytor.com>
Date: Sat, 04 Oct 2008 17:46:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: mtrr_cleanup: first 1M should be coverred in
 var mtrrs
References: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com> <1223157033-30217-2-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1223157033-30217-2-git-send-email-yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> +	/*
> +	 * [0, 1M) should always be coverred by var mtrr with WB
> +	 * and fixed mtrrs should take effective before var mtrr for it
> +	 */
> +	nr_range = add_range_with_merge(range, nr_range, 0,
> +					(1ULL<<(20 - PAGE_SHIFT)) - 1);
> +	/* sort the ranges */
> +	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
> +

The first 1 MB is a total don't care for the variable MTRRs -- they 
don't have to be covered *or* uncovered, since the entire first 1 MB is 
addressed by fixed MTRRs.

In practice, it is *likely* that you're going to want to merge it with a 
WB MTRR, but with various vendors doing all kinds of strange things on 
EFI-damaged platforms, it may not always be that way.

	-hpa

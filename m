Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbZD1KW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbZD1KW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932082AbZD1KV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:21:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40842 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758888AbZD1KV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:21:28 -0400
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] x86: MCE: Re-implement MCE log ring buffer as per-CPU ring buffer
From: Andi Kleen <andi@firstfloor.org>
References: <1240910841.6842.1163.camel@yhuang-dev.sh.intel.com>
Date: Tue, 28 Apr 2009 12:21:25 +0200
In-Reply-To: <1240910841.6842.1163.camel@yhuang-dev.sh.intel.com> (Huang Ying's message of "Tue, 28 Apr 2009 17:27:21 +0800")
Message-ID: <87eivdqdsq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> writes:
>
> ChangeLog:
>
> v2:
>
> - Use alloc_percpu() to allocate per_cpu mcelog buffer

Sorry, why didn't you just use DEFINE_PER_CPU ? That should work
as well and will be shorter.

Another thing I noticed. the "MACHINECHECK" signature was originally
for crash dump tools to find the log. If you change the format
you should change it to MACHINECHEC2 or so.

> +	size_t usize_limit;
> +
> +	/* Too large user buffer size may cause system not response */
> +	usize_limit = num_possible_cpus() * MCE_LOG_LEN * sizeof(struct mce);
> +	if (usize > usize_limit)
> +		usize = usize_limit;

Did you ever track down what happens here? I still find it worrying

Otherwise looks good.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

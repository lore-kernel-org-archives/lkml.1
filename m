Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZFVHtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZFVHtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZFVHtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:49:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48015 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbZFVHtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:49:24 -0400
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 19/23] x86/oprofile: use 64 bit wrmsr functions
From: Andi Kleen <andi@firstfloor.org>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
	<1244810140-20595-20-git-send-email-robert.richter@amd.com>
Date: Mon, 22 Jun 2009 09:49:23 +0200
In-Reply-To: <1244810140-20595-20-git-send-email-robert.richter@amd.com> (Robert Richter's message of "Fri, 12 Jun 2009 14:35:36 +0200")
Message-ID: <87my803dz0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter <robert.richter@amd.com> writes:
>  			val |= op_x86_get_ctrl(model, &counter_config[i]);
> @@ -251,7 +252,7 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
>  		if (val & OP_CTR_OVERFLOW)
>  			continue;
>  		oprofile_add_sample(regs, i);
> -		wrmsr(msrs->counters[i].addr, -(unsigned int)reset_value[i], -1);
> +		wrmsrl(msrs->counters[i].addr, -(s64)reset_value[i]);

These are not equivalent on 64bit because reset_value is a long,
so the new code doesn't 32->64 extend anymore. You would
need a (s32) cast, not a (s64)

I don't think if it causes real problems, but it looks suspicious.

That's all over in multiple files.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

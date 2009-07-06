Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbZGFVcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbZGFVcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZGFVcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:32:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37196 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbZGFVcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:32:31 -0400
Message-ID: <4A526D38.7000803@zytor.com>
Date: Mon, 06 Jul 2009 14:31:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86, msr]: remove code duplication
References: <1246890592-12256-1-git-send-email-borislav.petkov@amd.com>
In-Reply-To: <1246890592-12256-1-git-send-email-borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> -
> -	smp_call_function_many(mask, __rdmsr_on_cpu, &rv, 1);
> +	smp_call_function_single(this_cpu, msr_func, &rv, 1);
> +	smp_call_function_many(mask, msr_func, &rv, 1);
>  	preempt_enable();

Why are you using smp_call_function_single() to execute something *on
your own CPU*?

	-hpa

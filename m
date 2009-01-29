Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbZA2Wpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbZA2Wpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZA2Wpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:45:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:48964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912AbZA2Wpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:45:40 -0500
Message-ID: <4982315F.20705@kernel.org>
Date: Thu, 29 Jan 2009 14:44:47 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: allow 8 more cpus could be used
References: <49822B1D.9070708@kernel.org> <20090129224236.GD1465@elte.hu>
In-Reply-To: <20090129224236.GD1465@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Impact: fix left out MARCO
>>
>> X86_PC will be always enabled. so need to check if we have bigsmp 
>> support built in before cut off more than 8 cpus.
> 
> ah, that's a leftover reference to X86_PC. It can now be removed, together 
> with the Kconfig X86_PC option.
> 
>> -#if defined(CONFIG_X86_PC) && defined(CONFIG_X86_32)
>> +#if defined(CONFIG_X86_PC) && !defined(CONFIG_X86_BIGSMP)
>>  	if (def_to_bigsmp && nr_cpu_ids > 8) {
>>  		unsigned int cpu;
>>  		unsigned nr;
> 
> Could you please send a patch that removes both X86_PC and X86_BIGSMP - 
> and removes the above cutoff code too, so that it will be built-in all the 
> time?

sure. maybe we could keep X86_BIGSMP for a while. So someone don't enable BIGSMP for small system?

YH

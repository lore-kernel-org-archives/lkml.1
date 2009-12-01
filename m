Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZLAQQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZLAQQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZLAQQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:16:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56467 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbZLAQQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:16:14 -0500
Message-ID: <4B154018.4060605@zytor.com>
Date: Tue, 01 Dec 2009 08:11:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "Ma, Ling" <ling.ma@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] Compile Option Os versus O2 on latest x86 platform
References: <1259222752-8161-1-git-send-email-ling.ma@intel.com>	<20091126094930.GD32275@elte.hu>	<8FED46E8A9CA574792FC7AACAC38FE7714FED213BE@PDSMSX501.ccr.corp.intel.com> <20091201021459.43d2142a@infradead.org>
In-Reply-To: <20091201021459.43d2142a@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 02:14 AM, Arjan van de Ven wrote:
> On Tue, 1 Dec 2009 16:54:04 +0800
> "Ma, Ling" <ling.ma@intel.com> wrote:
> 
>> Hi Ingo
>>
>> Thanks for your correction, so we use perf stat --repeat 3 to test
>> volano, tbench, and kbuild, Because netperf has multiple items we may
>> send out later.
> 
> a key question is.. how much more memory do you have free due to -Os?
> (because memory is cache is performance on a system level as well)
> and how much less icache pressure is there?
> 

>From the re-run, it sounds like the only test that actually shows a
significant difference is volano.  From reading the numbers, it looks
like the improvements are almost exclusively in IPC i.e. better
scheduling -- all the other metrics are substantially worse; including a
10% increase in cache misses.

It would be interesting to see what functions are hot in volano.  It
might very well be that we could get a boost without significantly bloat
the kernel as a whole by picking out a couple of hot object files and
compiling those with -O2 or -O3.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZKBLLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZKBLLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 06:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754626AbZKBLLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 06:11:35 -0500
Received: from mga10.intel.com ([192.55.52.92]:14900 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754623AbZKBLLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 06:11:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,665,1249282800"; 
   d="scan'208";a="509859413"
Message-ID: <4AEEBE65.3070202@linux.intel.com>
Date: Mon, 02 Nov 2009 12:11:33 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com>
In-Reply-To: <4AEB3D95.50300@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> 
> This set of patches limits the number of repetitious messages which contain
> no additional information.  Much of this information is obtainable from the
> /proc and /sysfs.   Most of the messages are also sent to the kernel log
> buffer as KERN_DEBUG messages so it can be used to examine more closely any
> details specific to a processor.

What would be good is to put the information from the booting CPUs
into some buffer and print it visibly if there's a timeout detected on the BP.

Also power of two summaries at a bit odd, but ok.

> For Processor Information printout:
> 
>     [   90.968381] Summary Processor Information for CPUS: 0-639
>     [   90.972033] Genuine Intel(R) CPU    0000 @ 2.13GHz stepping 04

It would be good to print family/model in this line

>     [   90.981402] CPU: L1 I cache: 32K, L1 D cache: 32K
>     [   90.985888] CPU: L2 cache: 256K
>     [   90.988032] CPU: L3 cache: 24576K

I would recommend to drop the cache information; this can be easily
gotten at runtime and is often implied in the CPU name anyways
(and especially L1 and increasingly L2 too change only very rarely)

>     [   90.992032] MIN 4266.68 BogoMIPS (lpj=8533371)
>     [   91.000033] MAX 4267.89 BogoMIPS (lpj=8535789)

Perhaps an average too? You could put all that on one line.


> These lines have been moved to loglevel KERN_DEBUG:
> 
>     CPU: Physical Processor ID:
>     CPU: Processor Core ID:
>     CPU %d/0x%x -> Node %d
>     <cache line sizes per cpu>

I think you can just remove them.

>     CPUx is down

This should be still printed if there's a timeout, or rather print
a "CPUx is not down" message. Right now there's no timeout detection on shutdown, but
I guess that wouldn't be too hard to add.

-Andi

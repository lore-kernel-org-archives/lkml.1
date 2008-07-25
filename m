Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbYGYAiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbYGYAiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 20:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYGYAhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 20:37:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56240 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753111AbYGYAhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 20:37:52 -0400
Message-ID: <4889205C.9080806@sgi.com>
Date: Thu, 24 Jul 2008 17:37:48 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Dave Jones <davej@codemonkey.org.uk>, Paul Jackson <pj@sgi.com>,
       Tony Luck <tony.luck@intel.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robert Richter <robert.richter@amd.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sam Creasey <sammy@sammy.net>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use cpumask_of_cpu_map
References: <20080723171841.815234000@polaris-admin.engr.sgi.com> <20080723171841.997896000@polaris-admin.engr.sgi.com> <200807241245.17239.rusty@rustcorp.com.au> <4888C232.4090906@sgi.com>
In-Reply-To: <4888C232.4090906@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Rusty Russell wrote:
>> On Thursday 24 July 2008 03:18:42 Mike Travis wrote:
>>>     Note that the declaration of cpumask_of_cpu_map[] is initialized
>>>     so that cpumask_of_cpu(0) is defined early.  This assumes that
>>>     cpu 0 is the boot cpu.
>> Hi Mike,
>>
>>    Make this statically initialized please.  That almost guarantees there'll
>> be no problems.  It's a little tricky to do, but possible.  Patch below
>> tested on 32 bit x86 only.
> 
> I thought about it, but it didn't seem to be worth the effort.  One problem
> though, the cpumask bits are such that the LSB of the last word is cpu 0.
> So your initializer sets it up in reverse order.  I'll see if I can't
> figure out how to invert it (very tricky coding btw... ;-)

I thought since the cpumask_scnprintf prints out the bit map with the LSB
being cpu 0 that the bit layout was the same.  Further examination reveals
I was wrong about that.

The updated patchset to follow shortly after a bit more testing...

Thanks,
Mike

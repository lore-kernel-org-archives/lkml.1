Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbZJ1FYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbZJ1FYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbZJ1FYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:24:46 -0400
Received: from mga10.intel.com ([192.55.52.92]:30994 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757355AbZJ1FYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:24:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,638,1249282800"; 
   d="scan'208";a="741291916"
Message-ID: <4AE7D59D.9070307@linux.intel.com>
Date: Wed, 28 Oct 2009 06:24:45 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Mike Travis <travis@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] x86, mce: disable MCE if cpu has no MCE banks
References: <adaeip473qt.fsf@cisco.com> <4AE74D25.8090901@sgi.com> <4AE75DB9.3040702@sgi.com> <4AE7C396.7040109@jp.fujitsu.com>
In-Reply-To: <4AE7C396.7040109@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Mike Travis wrote:
>> Mike Travis wrote:
>>> Hi Roland,
>>>
>>> I've found that I'm getting one of these lines for every cpu:
>>>
>>> mce: CPU supports 0 MCE banks

That message can be just removed I think. I don't see much value in it
because the value is in sysfs and when you see the CPU type you can easily
determine it anyways.

I don't think the patch below really solves the problem because they
would have the same noise problem back once they switch from the simulator
to a real box which has banks.

> Hum, I suppose the line for CPU 0 was slightly different from others,
> because SHD means "this bank is shared bank and controlled by other".
> Maybe:
>  CPU 0 MCA banks CMCI:0 CMCI:1 CMCI:2 CMCI:3 CMCI:5 ... CMCI:21
> 
> But I agree that we could some work for this messages...
> Is it better to change the message level to debug from info?

Can be made INFO yes, but I would prefer not removing them
from the dmesg for now.

Perhaps they could be also compressed a bit like SRAT.

-Andi

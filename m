Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZFEF0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZFEF0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZFEF0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:26:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59680 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbZFEF0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:26:34 -0400
Message-ID: <4A28AAA1.1060203@redhat.com>
Date: Fri, 05 Jun 2009 08:18:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpumask: alloc blank cpumask left over
References: <4A2835D8.6040903@kernel.org> <4A28362B.7040804@kernel.org> <200906051428.08299.rusty@rustcorp.com.au>
In-Reply-To: <200906051428.08299.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Fri, 5 Jun 2009 06:31:31 am Yinghai Lu wrote:
>   
>> avoid suprise when MAXSMP is enabled
>>
>> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
>>     
>
> I understand the temptation, but two questions arise:
> 1) Shouldn't we actually audit to see if any of these are currently problems, 
> and
> 2) Should the non-MAXSMP alloc_cpumask_var_node (currently a noop) zero the 
> mask if __GFP_ZERO is set?
>   

If we go that route we should conditionally clear the bitmaps in 
alloc_cpumask_var().  I don't think we do, though.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


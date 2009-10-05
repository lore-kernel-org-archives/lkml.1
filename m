Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbZJESLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbZJESLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbZJESL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:11:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:59652 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbZJESL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:11:29 -0400
Message-ID: <4ACA3677.40407@kernel.org>
Date: Mon, 05 Oct 2009 11:09:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Tejun Heo <tj@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use near online node instead of round bin for numa
References: <4AC7974C.20304@kernel.org> <87my45yk79.fsf@basil.nowhere.org>
In-Reply-To: <87my45yk79.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> cpu to node mapping is set in following sequence:
>> 1. numa_init_array: set up roundbin from cpu to online node
>> 2. init_cpu_to_node: set that according to apicid_to_node[] according to srat
>> 		  only handle that node is online, and leave other cpu on node
>> 		  without ram (aka not online) to still round-bin
>> 3. later srat_detect_node for intel/amd, will use first_online node or near by
>>    node.
>>
>> problem is that setup_per_cpu_areas() is called between  2 and 3. the per_cpu
>> for cpu on node with ram is on different node. and could put that on node with
>> two hops away.
>>
>> so try add find_near_online_node() and call int init_cpu_to_node()
> 
> This fallback case should not really happen anyways, unless the BIOS is buggy
> (in this case it might better to completely reject the SRAT because
> more might be wrong).
SRAT is right, and some node has no ram installed.
> 
> Do you have a system where this is needed?

sure.

YH

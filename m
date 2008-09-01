Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbYIAJUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbYIAJUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYIAJUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:20:05 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:58643 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYIAJUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:20:03 -0400
Message-ID: <48BBB326.3080505@linux.vnet.ibm.com>
Date: Mon, 01 Sep 2008 14:47:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
References: <20080831174756.GA25790@balbir.in.ibm.com> <48BBAFDD.1000902@openvz.org>
In-Reply-To: <48BBAFDD.1000902@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> Balbir Singh wrote:
>> This is a rewrite of a patch I had written long back to remove struct page
>> (I shared the patches with Kamezawa, but never posted them anywhere else).
>> I spent the weekend, cleaning them up for 2.6.27-rc5-mmotm (29 Aug 2008).
>>
>> I've tested the patches on an x86_64 box, I've run a simple test running
>> under the memory control group and the same test running concurrently under
>> two different groups (and creating pressure within their groups). I've also
>> compiled the patch with CGROUP_MEM_RES_CTLR turned off.
>>
>> Advantages of the patch
>>
>> 1. It removes the extra pointer in struct page
>>
>> Disadvantages
>>
>> 1. It adds an additional lock structure to struct page_cgroup
>> 2. Radix tree lookup is not an O(1) operation, once the page is known
>>    getting to the page_cgroup (pc) is a little more expensive now.
> 
> And besides, we also have a global lock, that protects even lookup
> from this structure. Won't this affect us too much on bug-smp nodes?

Sorry, not sure I understand. The lookup is done under RCU. Updates are done
using the global lock. It should not be hard to make the radix tree per node
later (as an iterative refinement).

-- 
	Balbir

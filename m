Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbYIAJoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbYIAJoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYIAJnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:43:52 -0400
Received: from sacred.ru ([62.205.161.221]:37404 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbYIAJnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:43:51 -0400
Message-ID: <48BBB936.5040002@openvz.org>
Date: Mon, 01 Sep 2008 13:43:18 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
References: <20080831174756.GA25790@balbir.in.ibm.com> <48BBAFDD.1000902@openvz.org> <48BBB326.3080505@linux.vnet.ibm.com>
In-Reply-To: <48BBB326.3080505@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 01 Sep 2008 13:43:18 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Pavel Emelyanov wrote:
>> Balbir Singh wrote:
>>> This is a rewrite of a patch I had written long back to remove struct page
>>> (I shared the patches with Kamezawa, but never posted them anywhere else).
>>> I spent the weekend, cleaning them up for 2.6.27-rc5-mmotm (29 Aug 2008).
>>>
>>> I've tested the patches on an x86_64 box, I've run a simple test running
>>> under the memory control group and the same test running concurrently under
>>> two different groups (and creating pressure within their groups). I've also
>>> compiled the patch with CGROUP_MEM_RES_CTLR turned off.
>>>
>>> Advantages of the patch
>>>
>>> 1. It removes the extra pointer in struct page
>>>
>>> Disadvantages
>>>
>>> 1. It adds an additional lock structure to struct page_cgroup
>>> 2. Radix tree lookup is not an O(1) operation, once the page is known
>>>    getting to the page_cgroup (pc) is a little more expensive now.
>> And besides, we also have a global lock, that protects even lookup
>> from this structure. Won't this affect us too much on bug-smp nodes?
> 
> Sorry, not sure I understand. The lookup is done under RCU. Updates are done
> using the global lock. It should not be hard to make the radix tree per node
> later (as an iterative refinement).
> 

OOPS, indeed. Sorry for the confusion, then. :)

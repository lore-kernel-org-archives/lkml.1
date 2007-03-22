Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbXCVW4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbXCVW4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXCVW4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:56:49 -0400
Received: from www.cosmosbay.com ([86.65.150.131]:33964 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752703AbXCVW4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:56:49 -0400
Message-ID: <460309A5.6070404@cosmosbay.com>
Date: Thu, 22 Mar 2007 23:56:37 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Christoph Lameter <christoph@lameter.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: non-NUMA cache_free_alien() (was Re: [RFC] SLAB : NUMA cache_free_alien()
 very expensive because of virt_to_slab(objp); nodeid = slabp->nodeid;)
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org> <Pine.LNX.4.64.0703201716440.17799@graphe.net> <20070321024452.GA17532@one.firstfloor.org> <Pine.LNX.4.64.0703202006230.20568@graphe.net> <20070322212831.GA25665@linux-os.sc.intel.com> <4602FF57.7030001@cosmosbay.com> <20070322224045.GA3200@linux-os.sc.intel.com>
In-Reply-To: <20070322224045.GA3200@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 22 Mar 2007 23:56:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B a écrit :
> On Thu, Mar 22, 2007 at 11:12:39PM +0100, Eric Dumazet wrote:
>> Siddha, Suresh B a écrit :
>>> +	if (num_online_nodes() == 1)
>>> +		use_alien_caches = 0;
>>> +
>> Unfortunatly this part is wrong.
> 
> oops.
> 
>> You should check num_possible_nodes(), or nr_node_ids (this one is cheaper, 
>> its a variable instead of a function call)
> 
> But that is based on compile time option, isn't it? Perhaps I need
> to use some other mechanism to find out the platform is not NUMA capable..

nr_node_ids is defined to 1 if you compile a non NUMA kernel.

If CONFIG_NUMA is on, then nr_node_ids is a variable, that is filled with the 
maximum nodeid of possible node (+1). If your machine is not CPU hot plug 
capable, and you have say one node, (one dual core processor for example), 
then nr_node_ids will be set to 1
(see mm/page_alloc.c function setup_nr_node_ids() )

So this is OK for your need...


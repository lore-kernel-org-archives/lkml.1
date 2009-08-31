Return-Path: <linux-kernel-owner+w=401wt.eu-S1751556AbZHaMHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbZHaMHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZHaMHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:07:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44198 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZHaMHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:07:10 -0400
Message-ID: <b18a62cbada2801ab34d591ba65ef906.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090831111027.GI4770@balbir.in.ibm.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828132706.e35caf80.kamezawa.hiroyu@jp.fujitsu.com>
    <20090831111027.GI4770@balbir.in.ibm.com>
Date: Mon, 31 Aug 2009 21:07:10 +0900 (JST)
Subject: Re: [RFC][PATCH 4/5] memcg: per-cpu charge stock
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28
> 13:27:06]:
>
>>
>> For avoiding frequent access to res_counter at charge, add per-cpu
>> local charge. Comparing with modifing res_coutner (with percpu_counter),
>> this approach
>> Pros.
>> 	- we don't have to touch res_counter's cache line
>> 	- we don't have to chase res_counter's hierarchy
>> 	- we don't have to call res_counter function.
>> Cons.
>> 	- we need our own code.
>>
>> Considering trade-off, I think this is worth to do.
>
> I prefer the other part due to
>
> 1. Code reuse (any enhancements made will benefit us)
> 2. Custom batching that can be done easily
> 3. Remember hierarchy is explicitly enabled and we've documented that
> it is expensive

Hmm. the important point is we don't touch res_counter's cacheline in
fast path. And if we don't use memcg's percpu counter, more cacheline/TLB
will be necesary. (I think percpu counter is slow.)
plz rewrite memcg's percpu counter by youself if you want something generic.

I can't understand what you mention by (3).

Thanks,
-Kame



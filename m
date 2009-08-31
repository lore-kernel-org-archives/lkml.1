Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbZHaMJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbZHaMJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZHaMJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:09:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56714 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbZHaMJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:09:55 -0400
Message-ID: <360d07ecdf467c2e15231f420375ffee.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090831111146.GJ4770@balbir.in.ibm.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828132809.ad7cfebc.kamezawa.hiroyu@jp.fujitsu.com>
    <20090831111146.GJ4770@balbir.in.ibm.com>
Date: Mon, 31 Aug 2009 21:09:55 +0900 (JST)
Subject: Re: [RFC][PATCH 5/5] memcg: drain per cpu stock
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh さんは書きました：
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28
> 13:28:09]:
>
>>
>> Add function for dropping per-cpu stock of charges.
>> This is called when
>> 	- cpu is unplugged.
>> 	- force_empty
>> 	- recalim seems to be not easy.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> The complexity of this patch and additional code make percpu_counter
> more attractive. Why not work on percpu_counter if that is not as good
> as we expect it to be and in turn help other exploiters as well.

- percpu counter is slow.
- percpu counter is "counter". we use res_counter not as counter but as
  accounting for "limit". This "borrow" charges is core of this patch.
- Adding "flush" ops for percpu counter will be much more mess.
- This implementation handles mem->res and mem->memsw at the same time.
  This reduces much overhead.

Thanks,
-Kame


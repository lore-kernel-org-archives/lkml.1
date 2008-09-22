Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbYIVPPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbYIVPPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYIVPOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:14:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52753 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbYIVPOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:14:54 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <31600854.1222096483210.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 23 Sep 2008 00:14:43 +0900 (JST)
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: Re: [PATCH 9/13] memcg: lookup page cgroup (and remove pointer from struct page)
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       xemul@openvz.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1222095177.8533.14.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <1222095177.8533.14.camel@nimitz>
 <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080922201206.e73d9ce6.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>On Mon, 2008-09-22 at 20:12 +0900, KAMEZAWA Hiroyuki wrote:
>> +       /* we don't need too large hash */
>> +       default_pcg_hash_size = (max_pfn/ENTS_PER_CHUNK);
>> +       default_pcg_hash_size *= 2;
>> +       /* if too big, use automatic calclation */
>> +       if (default_pcg_hash_size > 1024 * 1024)
>> +               default_pcg_hash_size = 0;
>> +
>> +       pcg_hashtable = alloc_large_system_hash("PageCgroup Hash",
>> +                               sizeof(struct pcg_hash_head),
>> +                               default_pcg_hash_size,
>> +                               13,
>> +                               0,
>> +                               &pcg_hashshift,
>> +                               &pcg_hashmask,
>> +                               0);
>
>The one thing I don't see here is much explanation about how large this
>structure will get.
>
max 8MB. (1024 *1024 * 8)...I'll reduce this.

>Basing it on max_pfn makes me nervous because of what it will do on
>machines with very sparse memory.  Is this like sparsemem where the
>structure can be small enough to actually span all of physical memory,
>or will it be a large memory user?
>
I admit this calcuration is too easy. Hmm, based on totalram_pages is 
better. ok.


>Can you lay out how much memory this will use on a machine like Dave
>Miller's which has 1GB of memory at 0x0 and 1GB of memory at 1TB up in
>the address space?
>

>Also, how large do the hash buckets get in the average case?
>
on my 48GB box, hashtable was 16384bytes. (in dmesg log.)
(section size was 128MB.)

I'll rewrite this based on totalram_pages.

BTW, do you know difference between num_physpages and totalram_pages ?

Thanks,
-Kame

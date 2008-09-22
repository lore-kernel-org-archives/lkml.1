Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbYIVRfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbYIVRfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 13:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYIVRez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 13:34:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34666 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYIVRey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 13:34:54 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <4937651.1222104886847.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 23 Sep 2008 02:34:46 +0900 (JST)
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: Re: Re: Re: [PATCH 9/13] memcg: lookup page cgroup (and remove pointer from struct page)
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp,
       xemul@openvz.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1222099850.8533.60.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <1222099850.8533.60.camel@nimitz>
 <1222098450.8533.41.camel@nimitz>
	 <1222095177.8533.14.camel@nimitz>
	 <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080922201206.e73d9ce6.kamezawa.hiroyu@jp.fujitsu.com>
	 <31600854.1222096483210.kamezawa.hiroyu@jp.fujitsu.com>
	 <32459434.1222099038142.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Tue, 2008-09-23 at 00:57 +0900, kamezawa.hiroyu@jp.fujitsu.com wrote:
>> I'll add FLATMEM/SPARSEMEM support later. Could you wait for a while ?
>> Because we have lookup_page_cgroup() after this, we can do anything.
>
>OK, I'll stop harassing for the moment, and take a look at the cache. :)
>
Why I don't say "optimize this! now! more!" is where this is called is
limited now. only at charge/uncharge. This is not memmap.

 charge     ...the first page fault to the page
                  add to radix-tree
 uncharge   ...the last unmap aginst the page
                  remove from radix-tree.

I can make this faster by using charactoristics of FLATMEM and others.
(with more #ifdefs and codes.)
But would like to start from generic one because adding interface is
the first thing I have to do here.

BTW, to be honest, I don't like 2-level-table-lookup like
SPARSEMEM_EXTREME, here. A style like SPARSEMEM_VMEMMAP...using 
linear virtual address map will be goal of mine.

Thanks,
-Kame

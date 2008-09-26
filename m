Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYIZJeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYIZJeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYIZJeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:34:14 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:58990 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYIZJeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:34:13 -0400
Message-ID: <48DCAC1D.9020802@linux.vnet.ibm.com>
Date: Fri, 26 Sep 2008 15:02:13 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
       ryov@valinux.co.jp
Subject: Re: [PATCH 1/12] memcg avoid accounting special mappings not on LRU
References: <20080925151124.25898d22.kamezawa.hiroyu@jp.fujitsu.com> <20080925151307.f9cf352f.kamezawa.hiroyu@jp.fujitsu.com> <48DC9C92.4000408@linux.vnet.ibm.com> <20080926181726.359c77a8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080926181726.359c77a8.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 26 Sep 2008 13:55:54 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> KAMEZAWA Hiroyuki wrote:
>>> There are not-on-LRU pages which can be mapped and they are not worth to
>>> be accounted. (becasue we can't shrink them and need dirty codes to handle
>>> specical case) We'd like to make use of usual objrmap/radix-tree's protcol
>>> and don't want to account out-of-vm's control pages.
>>>
>>> When special_mapping_fault() is called, page->mapping is tend to be NULL 
>>> and it's charged as Anonymous page.
>>> insert_page() also handles some special pages from drivers.
>>>
>>> This patch is for avoiding to account special pages.
>>>
>> Hmm... I am a little concerned that with these changes actual usage will much
>> more than what we report in memory.usage_in_bytes. Why not move them to
>> non-reclaimable LRU list as unevictable pages (once those patches go in, we can
>> push this as well). 
> 
> Because they are not on LRU ...i.e. !PageLRU(page)
> 

I understand.. Thanks for clarifying.. my concern is w.r.t accounting, we
account it in RSS (file RSS).

-- 
	Balbir

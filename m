Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbXGaIix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbXGaIix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbXGaIim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:38:42 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41897 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbXGaIil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:38:41 -0400
Message-ID: <46AEF518.4000002@bull.net>
Date: Tue, 31 Jul 2007 10:38:48 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: David Mosberger-Tang <dmosberger@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] flush icache before set_pte take6. [4/4] optimization
 for cpus other than montecito
References: <20070731113543.93ffd964.kamezawa.hiroyu@jp.fujitsu.com>	 <20070731114155.5785123c.kamezawa.hiroyu@jp.fujitsu.com> <ed5aea430707302115h484620f1le51fc054436b273a@mail.gmail.com>
In-Reply-To: <ed5aea430707302115h484620f1le51fc054436b273a@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/07/2007 10:43:28,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/07/2007 10:43:29,
	Serialize complete at 31/07/2007 10:43:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Mosberger-Tang wrote:
> This seems crazy to me.  Flushing should occur according to the
> *architecture*, not model-by-model.  Even if we happen to get "lucky"
> on pre-Montecito CPUs, that doesn't justify such ugly hacks.  Or you
> really want to debug this *again* come next CPU?
> 
>   --david

O.K. let's say we flush by default: the global flag is set.

We can have a (short) list of the CPU models which do not require
this flush.

If all of the CPUs are on the list then clear the global flag. And:

static inline void sync_icache_dcache(pte_t pte) {
       if (pte_exec(pte) && global_flag)
               __sync_icache_dcache(pte);
}

Thanks,

Zoltan

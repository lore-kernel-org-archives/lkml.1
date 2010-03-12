Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686Ab0CLWdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 17:33:55 -0500
Received: from mga10.intel.com ([192.55.52.92]:28833 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934667Ab0CLWdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 17:33:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,628,1262592000"; 
   d="scan'208";a="548618807"
Message-ID: <4B9AC149.1010507@linux.intel.com>
Date: Fri, 12 Mar 2010 14:33:45 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: page_to_nid not linked in on PAE
References: <alpine.LSU.2.01.1003091210230.10157@obet.zrqbmnf.qr>	 <alpine.LSU.2.01.1003101128340.9318@obet.zrqbmnf.qr> <1268423424.2793.21.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1268423424.2793.21.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Jan, Even with out using the PG_head, PG_tail, PG_uncached and
> PG_hwpoison, by allowing the NODES_SHIFT to have a maximum value of 9 on
> 32bit kernel, can still result in the page flags to runout and result in
> this problem. Best solution for now is to limit the NODES_SHIFT to 5. I
> don't know of any platforms that have>  32nodes and where we care about
> 32bit linux kernel. So it should be ok as a fix. If someone in future
> cares about>  32 nodes for 32bit kernel, then we can think of a better
> solution. Do you agree? I copied Andi/Nick for their eyes aswell on
> this.

Seems like the right approach to me. Although it might be better to
use 1 3 or 1..4 or so, just in case someone else adds more page bits
later (I'm sure it'll happen again). Even 8 nodes should be plenty for
32bit.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbZFDIbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbZFDIbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZFDIbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:31:14 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:53299 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbZFDIbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:31:13 -0400
Date: Thu, 4 Jun 2009 16:31:10 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] remove memory.limit v.s. memsw.limit comparison.
Message-ID: <20090604083110.GD7504@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090604141043.9a1064fd.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090604141043.9a1064fd.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-06-04 14:10:43]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Removes memory.limit < memsw.limit at setting limit check completely.
> 
> The limitation "memory.limit <= memsw.limit" was added just because
> it seems sane ...if memory.limit > memsw.limit, only memsw.limit works.
> 
> But To implement this limitation, we needed to use private mutex and make
> the code a bit complated.
> As Nishimura pointed out, in real world, there are people who only want
> to use memsw.limit.
> 
> Then, this patch removes the check. user-land library or middleware can check
> this in userland easily if this really concerns.
> 
> And this is a good change to charge-and-reclaim.
> 
> Now, memory.limit is always checked before memsw.limit
> and it may do swap-out. But, if memory.limit == memsw.limit, swap-out is
> finally no help and hits memsw.limit again. So, let's allow the condition
> memory.limit > memsw.limit. Then we can skip unnecesary swap-out.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

We can't change behaviour this way without breaking userspace scripts,
API and code. What does it mean for people already using these
features? Does it break their workflow?

-- 
	Balbir

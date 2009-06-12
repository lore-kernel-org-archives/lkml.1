Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbZFLGWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbZFLGWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 02:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZFLGVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 02:21:52 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:51309 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbZFLGVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 02:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KDzL9wLevaolEMdB8DRNLm23UYF73fLmsjYUG7k07T1QW7h8sA9LoZM1Jv+PA4ViPH
         lvrvobpSLSy8SOZ7qJJ8dsrf2PBumrr5FdKOHHB8+7n8+lWGCLlThN64Ftm5SK3KgKCQ
         8d9jLiz7cnEqmarpmQtYEkPy2cmg+Rqz5xXxA=
MIME-Version: 1.0
In-Reply-To: <20090612143429.76ef2357.kamezawa.hiroyu@jp.fujitsu.com>
References: <Pine.LNX.4.64.0906110820170.2258@melkki.cs.Helsinki.FI>
	 <4A31C258.2050404@cn.fujitsu.com>
	 <20090612115501.df12a457.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090612124408.721ba2ae.kamezawa.hiroyu@jp.fujitsu.com>
	 <4A31D326.3030206@cn.fujitsu.com>
	 <20090612143429.76ef2357.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 12 Jun 2009 09:21:52 +0300
X-Google-Sender-Auth: a7de4a4c62f77798
Message-ID: <84144f020906112321x9912476sb42b5d811741e646@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] memcg: fix page_cgroup fatal error in FLATMEM 
	(Was Re: boot panic with memcg enabled
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hannes@cmpxchg.org, torvalds@linux-foundation.org,
       yinghai@kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 8:34 AM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Now, SLAB is configured in very early stage and it can be used in
> init routine now.
>
> But replacing alloc_bootmem() in FLAT/DISCONTIGMEM's page_cgroup()
> initialization breaks the allocation, now.
> (Works well in SPARSEMEM case...it supports MEMORY_HOTPLUG and
>  Size of page_cgroup is in reasonable size (< 1 << MAX_ORDER.)
>
> This patch revive FLATMEM+memory cgroup by using alloc_bootmem.
>
> In future,
> We stop to support FLATMEM (if no users) or rewrite codes for flatmem
> completely. But this will adds more messy codes and (big) overheads.
>
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Looks good to me!

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Do you want me to push this to Linus or will you take care of it?

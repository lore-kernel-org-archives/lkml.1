Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYKGCvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYKGCvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750698AbYKGCvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:51:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55420 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYKGCvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:51:13 -0500
Date: Fri, 7 Nov 2008 11:50:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, Rik van Riel <riel@redhat.com>,
       fernando@oss.ntt.co.jp, Jeff Moyer <jmoyer@redhat.com>,
       menage@google.com, ngupta@google.com,
       Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com
Subject: Re: [patch 2/4] io controller: biocgroup implementation
Message-Id: <20081107115030.7ccf3f07.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081106153135.790621895@redhat.com>
References: <20081106153022.215696930@redhat.com>
	<20081106153135.790621895@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 10:30:24 -0500
vgoyal@redhat.com wrote:

> 
> o biocgroup functionality.
> o Implemented new controller "bio"
> o Most of it picked from dm-ioband biocgroup implementation patches.
> 
page_cgroup implementation is changed and most of this patch needs rework.
please see the latest one. (I think most of new characteristics are useful
for you.)

One comment from me is
==
> +struct page_cgroup {
> +	struct list_head lru;		/* per cgroup LRU list */
> +	struct page *page;
> +	struct mem_cgroup *mem_cgroup;
> +	int flags;
> +#ifdef CONFIG_CGROUP_BIO
> +	struct list_head blist;		/* for bio_cgroup page list */
> +	struct bio_cgroup *bio_cgroup;
> +#endif
> +};
==

this blist is too bad. please keep this object small...

Maybe dm-ioband people will post his own new one. just making use of it is an idea.

Thanks,
-Kame



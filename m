Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbYIYIrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbYIYIrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYIYIqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:46:43 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:47795 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752999AbYIYIqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:46:42 -0400
Date: Thu, 25 Sep 2008 17:46:34 +0900 (JST)
Message-Id: <20080925.174634.02448435.taka@valinux.co.jp>
To: dm-devel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: ryov@valinux.co.jp, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, agk@sourceware.org,
       xemul@openvz.org, fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com
Subject: Re: [dm-devel] Re: [PATCH 4/8] bio-cgroup: Split the cgroup memory
 subsystem into two parts
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080925161400.602ddfdb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080924.191234.104048747.ryov@valinux.co.jp>
	<20080924.191309.189710495.ryov@valinux.co.jp>
	<20080925161400.602ddfdb.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I posted new ones.
>  - http://lkml.org/lkml/2008/9/25/33 
>  (changes in page_cgroup) http://lkml.org/lkml/2008/9/25/56
> (I'm not sure this gets Ack or Nack. but direction will not change.)
> 
> Then, please tell me if you have new troubles with new ones.
> Or if you have requests.
> Major changes are
> 
>   - page_cgroup.h is added.
>   - lookup_page_cgroup(struct page*), lock_page_cgroup() etc.. is exported.
>   - All page_cgroup are allocated at boot.
>   - you can use atomic operation to modify page_cgroup->flags.

Good new!

> One concern from me to this bio_cgroup is that this increases size of
> +#ifdef CONFIG_CGROUP_BIO
> +	struct list_head blist;		/* for bio_cgroup page list */
> +	struct bio_cgroup *bio_cgroup;
> +#endif
> struct page_cgroup...more 24bytes per 4096bytes.
> Could you reduce this ? I think 8bytes per memcg is reasonable.
> Can you move lru to bio itself ?

I have a plan on getting rid of the blist after your work is done,
whose design will depend on that all page_cgroups are preallocated.
I also think the size of bio_cgroup can be reduced if making bio_cgroup
contain a bio-cgroup ID instead of the pointer.

Just wait! :)

> This makes page_cgroup to be 64bytes from 40bytes and makes it larger
> than mem_map....
> After bio_cgroup, page_cgroup, allocated at boot, size on my 48GB box 
> will jump up.
> 480MB -> 760MB.
> 
> Thanks,
> -Kame



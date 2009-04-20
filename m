Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbZDTJi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbZDTJi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbZDTJiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:38:17 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:33365 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753555AbZDTJiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:38:16 -0400
Date: Mon, 20 Apr 2009 18:38:15 +0900 (JST)
Message-Id: <20090420.183815.226804723.ryov@valinux.co.jp>
To: righi.andrea@gmail.com
Cc: lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com,
       balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
       dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] io-throttle documentation
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090417102539.GA16838@linux>
References: <20090417102417.88a0ef93.kamezawa.hiroyu@jp.fujitsu.com>
	<49E7E1CF.6060209@cn.fujitsu.com>
	<20090417102539.GA16838@linux>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea, 

> Implementing bio-cgroup functionality as pure infrastructure framework
> instead of a cgroup subsystem would remove all this oddity and
> complexity.
> 
> For example, the actual functionality that I need for the io-throttle
> controller is just an interface to set and get the cgroup owner of a
> page. I think it should be the same also for other potential users of
> bio-cgroup.
> 
> So, what about implementing the bio-cgroup functionality as cgroup "page
> tracking" infrastructure and provide the following interfaces:
> 
> /*
>  * Encode the cgrp->css.id in page_group->flags
>  */
> void set_cgroup_page_owner(struct page *page, struct cgroup *cgrp);
> 
> /*
>  * Returns the cgroup owner of a page, decoding the cgroup id from
>  * page_cgroup->flags.
>  */
> struct cgroup *get_cgroup_page_owner(struct page *page);
> 
> This also wouldn't increase the size of page_cgroup because we can
> encode the cgroup id in the unused bits of page_cgroup->flags, as
> originally suggested by Kame.
> 
> And I think it could be used also by dm-ioband, even if it's not a
> cgroup-based subsystem... but I may be wrong. Ryo what's your opinion?

I looked your page_cgroup patch in io-throttle v14, It can also be used
by dm-ioband. But I'd like to eliminate lock_page_cgroup() to minimize
overhead. I'll rearrange the bio-cgroup patch according to the functions.

Thanks,
Ryo Tsuruta

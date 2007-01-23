Return-Path: <linux-kernel-owner+w=401wt.eu-S932088AbXAWEVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbXAWEVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 23:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932250AbXAWEVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 23:21:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:11943 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbXAWEVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 23:21:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tl/7LcbmhX6xmcVaKNbgASQMWZmQCXDvOxqh7XQVGo/mC4IXzcLcoTvTu4EVQUGCns6ccz9SxJelognxXrGkqa0jBVF5MB2WyUe3hBMxc/xgwX0DeuJ+2Fkarp3raKng2x8IOW5O8XvtZinJhNKQCd59XDpuMkIw/dkERJcktHM=
Message-ID: <4df04b840701222021w5e1aaab2if2ba7fc38d06d64b@mail.gmail.com>
Date: Tue, 23 Jan 2007 12:21:05 +0800
From: "yunfeng zhang" <zyf.zeroos@gmail.com>
To: "Al Boldi" <a1426z@gawab.com>
Subject: Re: [PATCH 2.6.20-rc5 1/1] MM: enhance Linux swap subsystem
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200701222300.41960.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4df04b840701212309l2a283357jbdaa88794e5208a7@mail.gmail.com>
	 <200701222300.41960.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Patched against 2.6.19 leads to:
>
> mm/vmscan.c: In function `shrink_pvma_scan_ptes':
> mm/vmscan.c:1340: too many arguments to function `page_remove_rmap'
>
> So changed
>  page_remove_rmap(series.pages[i], vma);
> to
>  page_remove_rmap(series.pages[i]);
>

I've worked on 2.6.19, but when update to 2.6.20-rc5, the function is changed.

> But your patch doesn't offer any swap-performance improvement for both swsusp
> or tmpfs.  Swap-in is still half speed of Swap-out.
>
>
Current Linux page allocation fairly provides pages for every process, since
swap daemon only is started when memory is low, so when it starts to scan
active_list, the private pages of processes are messed up with each other,
vmscan.c:shrink_list() is the only approach to attach disk swap page to page on
active_list, as the result, all private pages lost their affinity on swap
partition. I will give a testlater...

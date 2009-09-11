Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbZIKGPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbZIKGPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZIKGPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:15:41 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:46687
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbZIKGPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:15:41 -0400
X-IronPort-AV: E=Sophos;i="4.44,369,1249250400"; 
   d="scan'208";a="46357655"
Message-ID: <4AA9EAF7.5010401@inria.fr>
Date: Fri, 11 Sep 2009 08:15:19 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jsquyres@cisco.com, linux-rdma@vger.kernel.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull ummunotify
References: <aday6omhz9d.fsf@cisco.com>	<20090911145036.DB65.A69D9226@jp.fujitsu.com> <adatyzahvbm.fsf@cisco.com>
In-Reply-To: <adatyzahvbm.fsf@cisco.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > Can I this version already solved fork() + COW issue? if so, could you
>  > please explain what happen at fork. Obviously RDMA point to either parent
>  > or child page, not both. but Corrent COW rule is, first touch process
>  > get copyed page and other process still own original page. I think it's 
>  > unpecected behavior form RDMA.
>
> No, ummunotify doesn't really help that much with fork() + COW.  If a
> parent forks and then touches pages that are actively in use for RDMA,
> then of course they get COWed and RDMA goes to the wrong memory (from
> the point of view of the parent).
>   

My understanding of the code is that fork will end-up calling
copy_page_range() on all VMA, and copy_page_range() calls
mmu_notifier_invalidate_range_start() if  is_cow_mapping() is true,
which should be the case here. So you should get some invalidate events
on fork.

Brice


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZIKGLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZIKGLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZIKGLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:11:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38683 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZIKGLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:11:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [GIT PULL] please pull ummunotify
Cc: kosaki.motohiro@jp.fujitsu.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jsquyres@cisco.com,
       linux-rdma@vger.kernel.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <adatyzahvbm.fsf@cisco.com>
References: <20090911145036.DB65.A69D9226@jp.fujitsu.com> <adatyzahvbm.fsf@cisco.com>
Message-Id: <20090911150552.DB68.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 11 Sep 2009 15:11:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thank you explanation.

> 
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

So, Can we assume OpenMPI user process doesn't such thing?

Parhaps, madvise(DONTFORK) or vfork() avoid this issue. but I'm not
sure all program in the world do that.

> ummunotify does deal with the case where a process forks and touches
> memory that was used for RDMA but no longer is -- in that case, the MPI
> library has a chance to flush its registration cache because it will get
> a ummunotify event invalidating the old mapping.
> 
> The real purpose of ummunotify is to allow MPI implementations to cache
> registrations, even when the MPI library is used with an application
> that does funny things for allocation (mmap()/munmap() or brk(), etc).

Yup, that's very worth.




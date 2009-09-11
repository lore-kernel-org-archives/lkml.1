Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZIKQmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZIKQmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbZIKQmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:42:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbZIKQmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:42:52 -0400
Date: Fri, 11 Sep 2009 19:42:47 +0300
From: Gleb Natapov <gleb@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Roland Dreier <rdreier@cisco.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jsquyres@cisco.com,
       linux-rdma@vger.kernel.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull ummunotify
Message-ID: <20090911164247.GA6736@redhat.com>
References: <20090911145036.DB65.A69D9226@jp.fujitsu.com>
 <adatyzahvbm.fsf@cisco.com>
 <20090911150552.DB68.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911150552.DB68.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 03:11:36PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> Thank you explanation.
> 
> > 
> >  > Can I this version already solved fork() + COW issue? if so, could you
> >  > please explain what happen at fork. Obviously RDMA point to either parent
> >  > or child page, not both. but Corrent COW rule is, first touch process
> >  > get copyed page and other process still own original page. I think it's 
> >  > unpecected behavior form RDMA.
> > 
> > No, ummunotify doesn't really help that much with fork() + COW.  If a
> > parent forks and then touches pages that are actively in use for RDMA,
> > then of course they get COWed and RDMA goes to the wrong memory (from
> > the point of view of the parent).
> 
> So, Can we assume OpenMPI user process doesn't such thing?
> 
> Parhaps, madvise(DONTFORK) or vfork() avoid this issue. but I'm not
> sure all program in the world do that.
> 
MPI (or is it libibverbs?) marks all registered memory as DONTFORK.

--
			Gleb.

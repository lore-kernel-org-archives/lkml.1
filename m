Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbZBEREz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbZBEREz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZBEREr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:04:47 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43776 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbZBEREq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:04:46 -0500
Date: Thu, 5 Feb 2009 09:06:17 -0800
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>, wli@movementarian.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, shai@scalex86.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch] mm: Fix SHM_HUGETLB to work with users in
	hugetlb_shm_group
Message-ID: <20090205170617.GB7490@us.ibm.com>
References: <20090204221121.GD10229@movementarian.org> <20090205004157.GC6794@localdomain> <20090205104735.ECDA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205104735.ECDA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Operating-System: Linux 2.6.29-rc3-00011-ga610760 (x86_64)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.02.2009 [11:03:09 +0900], KOSAKI Motohiro wrote:
> (cc to Mel and Nishanth)
> 
> I think this requirement is reasonable. but I also hope Mel or Nishanth
> review this.
> 
> 
> <<intentionally full quote>>
> 
> > On Wed, Feb 04, 2009 at 05:11:21PM -0500, wli@movementarian.org wrote:
> > >On Wed, Feb 04, 2009 at 02:04:28PM -0800, Ravikiran G Thirumalai wrote:
> > >> ...
> > >> As I see it we have the following options to fix this inconsistency:
> > >> 1. Do not depend on RLIMIT_MEMLOCK for hugetlb shm mappings.  If a user
> > >>    has CAP_IPC_LOCK or if user belongs to /proc/sys/vm/hugetlb_shm_group,
> > >>    he should be able to use shm memory according to shmmax and shmall OR
> > >> 2. Update the hugetlbpage documentation to mention the resource limit based
> > >>    limitation, and remove the useless /proc/sys/vm/hugetlb_shm_group sysctl
> > >> Which one is better?  I am leaning towards 1. and have a patch ready for 1.
> > >> but I might be missing some historical reason for using RLIMIT_MEMLOCK with
> > >> SHM_HUGETLB.
> > >
> > >We should do (1) because the hugetlb_shm_group and CAP_IPC_LOCK bits
> > >should both continue to work as they did prior to RLIMIT_MEMLOCK -based
> > >management of hugetlb. Please make sure the new RLIMIT_MEMLOCK -based
> > >management still enables hugetlb shm when hugetlb_shm_group and
> > >CAP_IPC_LOCK don't apply.
> > >
> > 
> > OK, here's the patch.
> > 
> > Thanks,
> > Kiran
> > 
> > 
> > Fix hugetlb subsystem so that non root users belonging to hugetlb_shm_group
> > can actually allocate hugetlb backed shm.
> > 
> > Currently non root users cannot even map one large page using SHM_HUGETLB
> > when they belong to the gid in /proc/sys/vm/hugetlb_shm_group.
> > This is because allocation size is verified against RLIMIT_MEMLOCK resource
> > limit even if the user belongs to hugetlb_shm_group.
> > 
> > This patch
> > 1. Fixes hugetlb subsystem so that users with CAP_IPC_LOCK and users
> >    belonging to hugetlb_shm_group don't need to be restricted with
> >    RLIMIT_MEMLOCK resource limits
> > 2. If a user has sufficient memlock limit he can still allocate the hugetlb
> >    shm segment.
> > 
> > Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Seems reasonable.

Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

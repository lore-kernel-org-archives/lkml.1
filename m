Return-Path: <linux-kernel-owner+w=401wt.eu-S1757969AbZBDWLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969AbZBDWLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZBDWLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:11:23 -0500
Received: from movementarian.org ([79.99.65.163]:45154 "EHLO movementarian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbZBDWLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:11:23 -0500
Date: Wed, 4 Feb 2009 17:11:21 -0500
From: wli@movementarian.org
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Cannot use SHM_HUGETLB as a regular user
Message-ID: <20090204221121.GD10229@movementarian.org>
References: <20090204220428.GA6794@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204220428.GA6794@localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 02:04:28PM -0800, Ravikiran G Thirumalai wrote:
[..]
> However, setting up hugetlb_shm_group with the right gid does not work!
> Looks like hugetlb uses mlock based rlimits which cause shmget
> with SHM_HUGETLB to fail with -ENOMEM.  Setting up right rlimits for mlock
> through /etc/security/limits.conf works though (regardless of
> hugetlb_shm_group).
> I understand most oracle users use this rlimit to use largepages.
> But why does this need to be based on mlock!? We do have shmmax and shmall
> to restrict this resource.
> As I see it we have the following options to fix this inconsistency:
> 1. Do not depend on RLIMIT_MEMLOCK for hugetlb shm mappings.  If a user
>    has CAP_IPC_LOCK or if user belongs to /proc/sys/vm/hugetlb_shm_group,
>    he should be able to use shm memory according to shmmax and shmall OR
> 2. Update the hugetlbpage documentation to mention the resource limit based
>    limitation, and remove the useless /proc/sys/vm/hugetlb_shm_group sysctl
> Which one is better?  I am leaning towards 1. and have a patch ready for 1.
> but I might be missing some historical reason for using RLIMIT_MEMLOCK with
> SHM_HUGETLB.

We should do (1) because the hugetlb_shm_group and CAP_IPC_LOCK bits
should both continue to work as they did prior to RLIMIT_MEMLOCK -based
management of hugetlb. Please make sure the new RLIMIT_MEMLOCK -based
management still enables hugetlb shm when hugetlb_shm_group and
CAP_IPC_LOCK don't apply.


-- wli

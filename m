Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbZBEXdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbZBEXdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZBEXdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:33:03 -0500
Received: from movementarian.org ([79.99.65.163]:47800 "EHLO movementarian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbZBEXdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:33:01 -0500
Date: Thu, 5 Feb 2009 18:32:57 -0500
From: wli@movementarian.org
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, shai@scalex86.org
Subject: Re: [patch] mm: Fix SHM_HUGETLB to work with users in hugetlb_shm_group
Message-ID: <20090205233257.GH10229@movementarian.org>
References: <20090204220428.GA6794@localdomain> <20090204221121.GD10229@movementarian.org> <20090205004157.GC6794@localdomain> <20090205132529.GA12132@csn.ul.ie> <20090205190851.GA6692@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205190851.GA6692@localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 01:25:29PM +0000, Mel Gorman wrote:
>> This should be split into another patch (i.e. three in all). The
>> first patch allows users in thh shm_group to use huge pages. The
>> second that accounts for locked_shm properly. The third allows
>> users with a high enough locked rlimit to use shmget() with
>> hugepages. However, my feeling right now would be to ack 1,
>> re-reread 2 and nak 3.

I'm saying to ack all 3 for backward compatibility reasons, once
they're fixed up according to your other commentary.

On Thu, Feb 05, 2009 at 11:08:51AM -0800, Ravikiran G Thirumalai wrote:
> I totally agree.  In fact yesterday I was thinking of resending
> this patch to not account for shm memory when a user is not
> validated against rlimits (when he has CAP_IPC_LOCK or if he
> belongs to the sysctl_hugetlb_shm_group).
> As I see it there must be two parts:
> 1. Free ticket to CAP_IPC_LOCK and users belonging to
>    sysctl_hugetlb_shm_group
> 2. Patch to have users not having CAP_IPC_LOCK or
>    sysctl_hugetlb_shm_group to check against memlock
>    rlimits, and account it.  Also mark this deprecated in
>    feature-removal-schedule.txt
> Would this be OK?

This is the ideal scenario, except I thought the rlimit was destined
to replace the other methods, not vice-versa. I don't really mind
going this way, but maybe we should check in with the rlimit authors.


-- wli

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZBFB3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZBFB3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZBFB3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:29:07 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:53715 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZBFB3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:29:06 -0500
Date: Thu, 5 Feb 2009 17:28:58 -0800
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: wli@movementarian.org
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, shai@scalex86.org
Subject: Re: [patch] mm: Fix SHM_HUGETLB to work with users in
	hugetlb_shm_group
Message-ID: <20090206012858.GB8946@localdomain>
References: <20090204220428.GA6794@localdomain> <20090204221121.GD10229@movementarian.org> <20090205004157.GC6794@localdomain> <20090205132529.GA12132@csn.ul.ie> <20090205190851.GA6692@localdomain> <20090205233257.GH10229@movementarian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205233257.GH10229@movementarian.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 06:32:57PM -0500, wli@movementarian.org wrote:
>On Thu, Feb 05, 2009 at 11:08:51AM -0800, Ravikiran G Thirumalai wrote:
>> I totally agree.  In fact yesterday I was thinking of resending
>> this patch to not account for shm memory when a user is not
>> validated against rlimits (when he has CAP_IPC_LOCK or if he
>> belongs to the sysctl_hugetlb_shm_group).
>> As I see it there must be two parts:
>> 1. Free ticket to CAP_IPC_LOCK and users belonging to
>>    sysctl_hugetlb_shm_group
>> 2. Patch to have users not having CAP_IPC_LOCK or
>>    sysctl_hugetlb_shm_group to check against memlock
>>    rlimits, and account it.  Also mark this deprecated in
>>    feature-removal-schedule.txt
>> Would this be OK?
>
>This is the ideal scenario, except I thought the rlimit was destined
>to replace the other methods, not vice-versa. I don't really mind
>going this way, but maybe we should check in with the rlimit authors.

RLIMIT_MEMLOCK for SHM_HUGETLB seems bad and unrelated!  And as Mel rightly
pointed out,  currently rlimits are checked for hugetlb shm but not for
hugetlb mmaps.  Unless whoever authored the rlimit limitation comes forward
with a good explanation, I think it should be deprecated.

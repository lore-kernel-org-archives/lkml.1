Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbYERTzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbYERTzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYERTyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 15:54:53 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:34469 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbYERTyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 15:54:51 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jamie@shareable.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
From: Andi Kleen <andi@firstfloor.org>
References: <482DDA56.6000301@redhat.com>
	<20080516130545.845a3be9.akpm@linux-foundation.org>
Date: Sun, 18 May 2008 21:54:48 +0200
In-Reply-To: <20080516130545.845a3be9.akpm@linux-foundation.org> (Andrew Morton's message of "Fri, 16 May 2008 13:05:45 -0700")
Message-ID: <87ej7zcrqv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 May 2008 19:47:47.0018 (UTC) FILETIME=[0BEC32A0:01C8B920]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 16 May 2008 14:02:46 -0500
> Eric Sandeen <sandeen@redhat.com> wrote:
>
>> A collection of patches to make ext3 & 4 use barriers by
>> default, and to call blkdev_issue_flush on fsync if they
>> are enabled.
>
> Last time this came up lots of workloads slowed down by 30% so I
> dropped the patches in horror.

Didn't ext4 have some new checksum trick to avoid them?

> I just don't think we can quietly go and slow everyone's machines down
> by this much.  The overhead of journalling is already pretty horrid.
>
> If we were seeing a significant number of "hey, my disk got wrecked"

There used to be a couple of reports of people doing

some write workload
use automatic power switch to reset
turn on again
repeat for 24 hours

getting consistent corruption after some time <24hours and those
went away with barriers.

> Do we know which distros are enabling barriers by default?

SUSE did for some releases, although reiserfs used to be the default there
(but that one uses barriers too if the disk supports them) 

BTW for a lot of distros which default to LVM install it won't make 
any difference because DM right now doesn't pass barriers through.
I have a patch queued for that for the one-disk case at least, but it 
didn't make .26-rc.

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S934229AbZDAUW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934229AbZDAUW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZDAUWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:22:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49185 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbZDAUWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:22:13 -0400
To: Jeff Layton <jlayton@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: guard against jiffies wraparound on inode->dirtied_when checks (try #3)
From: Andi Kleen <andi@firstfloor.org>
References: <1238607475-8203-1-git-send-email-jlayton@redhat.com>
Date: Wed, 01 Apr 2009 22:22:06 +0200
In-Reply-To: <1238607475-8203-1-git-send-email-jlayton@redhat.com> (Jeff Layton's message of "Wed,  1 Apr 2009 13:37:55 -0400")
Message-ID: <87y6ukktu9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:
>
> The problem is that these checks assume that dirtied_when is updated
> periodically. If an inode is continuously being used for I/O it can be
> persistently marked as dirty and will continue to age. Once the time
> difference between dirtied_when and the jiffies value it is being
> compared to is greater than or equal to half the maximum of the jiffies
> type, the logic of the time_*() macros inverts and the opposite of what
> is needed is returned. On 32-bit architectures that's just under 25 days
> (assuming HZ == 1000).

I wonder if this can happen in other places using jiffies time stamp
too. Why not? Perhaps that check macro should be in timer.h and some auditing done
over the whiole code base?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.

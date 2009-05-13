Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbZEMJT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbZEMJT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 05:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbZEMJTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 05:19:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33162 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbZEMJTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 05:19:47 -0400
Date: Wed, 13 May 2009 11:19:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       David Rientjes <rientjes@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 3/6] mm, PM/Freezer: Disable OOM killer when tasks are
	frozen
Message-ID: <20090513091942.GC27261@elf.ucw.cz>
References: <200905070040.08561.rjw@sisk.pl> <200905101548.57557.rjw@sisk.pl> <200905131032.53624.rjw@sisk.pl> <200905131037.50011.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905131037.50011.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-05-13 10:37:49, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Currently, the following scenario appears to be possible in theory:
> 
> * Tasks are frozen for hibernation or suspend.
> * Free pages are almost exhausted.
> * Certain piece of code in the suspend code path attempts to allocate
>   some memory using GFP_KERNEL and allocation order less than or
>   equal to PAGE_ALLOC_COSTLY_ORDER.
> * __alloc_pages_internal() cannot find a free page so it invokes the
>   OOM killer.
> * The OOM killer attempts to kill a task, but the task is frozen, so
>   it doesn't die immediately.
> * __alloc_pages_internal() jumps to 'restart', unsuccessfully tries
>   to find a free page and invokes the OOM killer.
> * No progress can be made.
> 
> Although it is now hard to trigger during hibernation due to the
> memory shrinking carried out by the hibernation code, it is
> theoretically possible to trigger during suspend after the memory
> shrinking has been removed from that code path.  Moreover, since
> memory allocations are going to be used for the hibernation memory
> shrinking, it will be even more likely to happen during hibernation.
> 
> To prevent it from happening, introduce the oom_killer_disabled
> switch that will cause __alloc_pages_internal() to fail in the
> situations in which the OOM killer would have been called and make
> the freezer set this switch after tasks have been successfully
> frozen.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

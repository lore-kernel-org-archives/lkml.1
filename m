Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbXJADhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbXJADhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 23:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXJADhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 23:37:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbXJADhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 23:37:01 -0400
Date: Sun, 30 Sep 2007 23:36:05 -0400
From: Dave Jones <davej@redhat.com>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add ability to dump mapped pages with
	/proc/sys/vm/drop_caches
Message-ID: <20071001033605.GA11497@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Soeren Sandmann <sandmann@daimi.au.dk>,
	linux-kernel@vger.kernel.org
References: <ye8641s2fp4.fsf@camel11.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ye8641s2fp4.fsf@camel11.daimi.au.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2007 at 08:03:51PM +0200, Soeren Sandmann wrote:
 > This patch adds the ability to drop mapped pages with
 > /proc/sys/vm/drop_caches. This is useful to get repeatable
 > measurements of startup time for applications. 
 > 
 > Without it, pages that are mapped in already-running applications will
 > not get dropped, so the time measured will not be a true cold-cache
 > time.
 > 
 > Rik pointed out that "be_atomic" is a bit pointless since there is a
 > race on SMP anyway where pages can be added. However, it is there in
 > the existing code, so I added it for the new code as well. Does anyone
 > know why it's there?
 
this cset added it (and has a pretty explanatory commit msg)

	Dave

commit fc9a07e7bf1a76e710f5df017abb07628db1781d
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Sun Jul 15 23:38:14 2007 -0700

    invalidate_mapping_pages(): add cond_resched
    
    invalidate_mapping_pages() can sometimes take a long time (millions of pages
    to free).  Long enough for the softlockup detector to trigger.
    
    We used to have a cond_resched() in there but I took it out because the
    drop_caches code calls invalidate_mapping_pages() under inode_lock.
    
    The patch adds a nasty flag and puts the cond_resched() back.



-- 
http://www.codemonkey.org.uk

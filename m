Return-Path: <linux-kernel-owner+w=401wt.eu-S1751770AbYEFFtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbYEFFtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762829AbYEFFtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:49:01 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:38173 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbYEFFtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:49:00 -0400
Message-ID: <481FF115.8030503@linux.vnet.ibm.com>
Date: Tue, 06 May 2008 11:18:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: on CONFIG_MM_OWNER=y, kernel panic is possible.
References: <20080506142255.AC5D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080506142255.AC5D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> on CONFIG_MM_OWNER=y (that is automatically turned on by mem-cgroup),
> kernel panic is possible by following scenario in mm_update_next_owner().
> 
> 1. mm_update_next_owner() is called.
> 2. found caller task in do_each_thread() loop.
> 3. thus, BUG_ON(c == p) is true, it become kernel panic.
> 
> end up, We should left out current task.
> 
> 

That is not possible. If you look at where mm_update_next_owner() is called
from, we call it from

exit_mm() and exec_mmap()

In both cases, we ensure that the task's mm has changed (to NULL and the new mm
respectively), before we call mm_update_next_owner(), hence c->mm can never be
equal to p->mm.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

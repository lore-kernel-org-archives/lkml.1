Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYKTITd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYKTITd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 03:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYKTITY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 03:19:24 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:42992 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbYKTITY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 03:19:24 -0500
Date: Thu, 20 Nov 2008 13:49:24 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Don't allow priority switch to realtime when
	the task doesn't belong to init_task_group and when
	CONFIG_RT_GROUP_SCHED isn't set
Message-ID: <20081120081924.GB4349@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20081120061854.GA4349@in.ibm.com> <20081120075829.GA21785@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120075829.GA21785@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 08:58:29AM +0100, Ingo Molnar wrote:
> <snip>
> hm, another option would be, instead of denying something (which 
> denial might not even be noticed by the app) that the app clearly has 
> enough privilege to request - to just act upon it and move the task to 
> the init_task_group?

Thought about that option, but decided against it because:

- The task was started in a group which is not "equipped" to handle
  rt tasks (no rt_rq for the group because CONFIG_RT_GROUP_SCHED=n). So
  the task shouldn't have been started in such a group in the first
  place.
- We could move the task silently to init_task_group (which is kind
  of done now with the task being placed in init_task_group's rq), but
  that's not what a user would have expected when he started a task
  under a group.

Also, silently moving the task to init_task_group would cause confusion
later when the task drops the RT privilege. As Dhaval is asking in the
other thread, which group do we move it to now ?

Regards,
Bharata.

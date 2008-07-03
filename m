Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYGCOEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYGCOEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYGCOEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:04:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56307 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754664AbYGCOET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:04:19 -0400
Date: Thu, 3 Jul 2008 10:04:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zhang Rui <rui.zhang@intel.com>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, <harbour@sfinx.od.ua>
Subject: Re: [linux-pm] [PATCH 1/2] introduce new interface schedule_work_on
In-Reply-To: <1215071809.3214.0.camel@rzhang-dt.sh.intel.com>
Message-ID: <Pine.LNX.4.44L0.0807031001580.2410-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008, Zhang Rui wrote:

> This interface allows adding a job on a specific cpu.
> 
> Although a work struct on a cpu will be scheduled to other cpu if the cpu dies,
> there is a recursion if a work task tries to offline the cpu it's running on.
> we need to schedule the task to a specific cpu in this case.
> http://bugzilla.kernel.org/show_bug.cgi?id=10897
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> Tested-by: Rus <harbour@sfinx.od.ua>
> ---
>  include/linux/workqueue.h |    1 +
>  kernel/workqueue.c        |   38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
> 
> Index: linux-2.6/include/linux/workqueue.h
> ===================================================================
> --- linux-2.6.orig/include/linux/workqueue.h	2008-07-03 11:13:23.000000000 +0800
> +++ linux-2.6/include/linux/workqueue.h	2008-07-03 11:13:25.000000000 +0800
> @@ -188,6 +188,7 @@
>  extern void flush_scheduled_work(void);
>  
>  extern int schedule_work(struct work_struct *work);
> +extern int schedule_work_on(int cpu, struct work_struct *work);
>  extern int schedule_delayed_work(struct delayed_work *work, unsigned long delay);
>  extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
>  					unsigned long delay);

Is there some reason you don't export queue_work_on?  After all, 
queue_delayed_work_on is exported.

Alan Stern


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762805AbYEEXAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762805AbYEEXAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760701AbYEEXAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:00:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56936 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbYEEXAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:00:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=UpFXLDDdFP3m5BsWhJtuqMpCOTaNgUSrs8vH8EIpkuwBnOfaBfQDiDNDR6oTByLPK
	eHgqrnCfQxWzF9mvYMrlQ==
Message-ID: <6599ad830805051600n73109edbx73ca2b5e9377d888@mail.gmail.com>
Date: Mon, 5 May 2008 16:00:11 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [-mm][PATCH 2/4] Enhance cgroup mm_owner_changed callback to add task information
Cc: linux-mm@kvack.org, "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080503213804.3140.26503.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain>
	 <20080503213804.3140.26503.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Andrew suggested, can you improve the documentation? Ideally, there
should be a paragraph in Documentation/cgroups.txt that describes the
circumstances (including locking state) in which the callback is
called.

Paul

On Sat, May 3, 2008 at 2:38 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>
>  This patch adds an additional field to the mm_owner callbacks. This field
>  is required to get to the mm that changed.
>
>  Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>  ---
>
>   include/linux/cgroup.h |    3 ++-
>   kernel/cgroup.c        |    2 +-
>   2 files changed, 3 insertions(+), 2 deletions(-)
>
>  diff -puN kernel/cgroup.c~cgroup-add-task-to-mm--owner-callbacks kernel/cgroup.c
>  --- linux-2.6.25/kernel/cgroup.c~cgroup-add-task-to-mm--owner-callbacks 2008-05-04 02:53:05.000000000 +0530
>  +++ linux-2.6.25-balbir/kernel/cgroup.c 2008-05-04 02:53:05.000000000 +0530
>  @@ -2772,7 +2772,7 @@ void cgroup_mm_owner_callbacks(struct ta
>                         if (oldcgrp == newcgrp)
>                                 continue;
>                         if (ss->mm_owner_changed)
>  -                               ss->mm_owner_changed(ss, oldcgrp, newcgrp);
>  +                               ss->mm_owner_changed(ss, oldcgrp, newcgrp, new);
>                 }
>         }
>   }
>  diff -puN include/linux/cgroup.h~cgroup-add-task-to-mm--owner-callbacks include/linux/cgroup.h
>  --- linux-2.6.25/include/linux/cgroup.h~cgroup-add-task-to-mm--owner-callbacks  2008-05-04 02:53:05.000000000 +0530
>  +++ linux-2.6.25-balbir/include/linux/cgroup.h  2008-05-04 02:53:05.000000000 +0530
>  @@ -310,7 +310,8 @@ struct cgroup_subsys {
>          */
>         void (*mm_owner_changed)(struct cgroup_subsys *ss,
>                                         struct cgroup *old,
>  -                                       struct cgroup *new);
>  +                                       struct cgroup *new,
>  +                                       struct task_struct *p);
>         int subsys_id;
>         int active;
>         int disabled;
>  _
>
>  --
>         Warm Regards,
>         Balbir Singh
>         Linux Technology Center
>         IBM, ISTL
>

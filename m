Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZGCIgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZGCIgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZGCIfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:35:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50139 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbZGCIfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:35:54 -0400
Message-ID: <4A4DC327.3080004@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 16:36:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 7/9] [RFC] Support multiply-bindable cgroup subsystems
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com> <20090702021128.14469.3360.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090702021128.14469.3360.stgit@menage.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> [RFC] Support multiply-bindable cgroup subsystems
> 
> This patch allows a cgroup subsystem to be marked as bindable on
> multiple cgroup hierarchies independently, when declared in
> cgroup_subsys.h via MULTI_SUBSYS() rather than SUBSYS().
> 
> The state for such subsystems cannot be accessed directly from a
> task->cgroups (since there's no unique mapping for a task) but instead
> must be accessed via a particular control group object.
> 
> Multiply-bound subsystems are useful in cases where there's no direct
> correspondence between the cgroup configuration and some property of
> the kernel outside of the cgroups subsystem.  So this would not be
> applicable to e.g. the CFS cgroup, since there has to a unique mapping
> from a task to its CFS run queue.
> 
> As an example, the "debug" subsystem is marked multiply-bindable,
> since it has no state outside the cgroups framework itself.
> 

Great, this makes the debug subsystem more useful. Sometimes
I want to see some debug info in different hierarchies, but
I can't just because it can only be bound to one hierarchy.

> Example usage:
> 
> mount -t cgroup -o name=foo,debug,cpu cgroup /mnt1
> mount -t cgroup -o name=bar,debug,memory cgroup /mnt2
> 
> Open Issues:
> 
> - in the current version of this patch, mounting a cgroups hierarchy
>   with no options does *not* get you any of the multi-bindable
>   subsystems; possibly for consistency it should give you all of the
>   multi-bindable subsystems as well as all of the single-bindable
>   subsystems.
> 

Yeah, the latter is preferrable.

> - how can we avoid the checkpatch.pl errors due to creative use of
>   macros to generate enum names?

checkpatch.pl can sometimes generate false-positive, let's happily
ignore those "errors". ;)

But it whould be better if those macros can be handled in a cleaner way.


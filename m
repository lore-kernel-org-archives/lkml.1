Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0BMDTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 22:19:52 -0500
Received: from mail-px0-f191.google.com ([209.85.216.191]:33266 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0BMDTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 22:19:51 -0500
X-Greylist: delayed 1510 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Feb 2010 22:19:51 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BGZVHdBjOtk3v2wAwQQuzLDE/Medo8dJMnpzP92eAqvPUmYWXjRRXwcKlucfIAvZGl
         iwyCXqAlUwjtHMlgEWpA2wVOYerPOAO1A+KdEEWxCa06KjZjY/7VYXjRGcT6EDxNtGqH
         zxagXNUSGSWWHHFPmY0TmBBMONrq/TyaT8KmI=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002100228240.8001@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1002100228240.8001@chino.kir.corp.google.com>
Date: Sat, 13 Feb 2010 11:49:20 +0900
Message-ID: <28c262361002121849s68754559gf1e6f1b64cbd083f@mail.gmail.com>
Subject: Re: [patch 2/7 -mm] oom: sacrifice child with highest badness score 
	for parent
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 1:32 AM, David Rientjes <rientjes@google.com> wrote:
> When a task is chosen for oom kill, the oom killer first attempts to
> sacrifice a child not sharing its parent's memory instead.
> Unfortunately, this often kills in a seemingly random fashion based on
> the ordering of the selected task's child list.  Additionally, it is not
> guaranteed at all to free a large amount of memory that we need to
> prevent additional oom killing in the very near future.
>
> Instead, we now only attempt to sacrifice the worst child not sharing its
> parent's memory, if one exists.  The worst child is indicated with the
> highest badness() score.  This serves two advantages: we kill a
> memory-hogging task more often, and we allow the configurable
> /proc/pid/oom_adj value to be considered as a factor in which child to
> kill.
>
> Reviewers may observe that the previous implementation would iterate
> through the children and attempt to kill each until one was successful
> and then the parent if none were found while the new code simply kills
> the most memory-hogging task or the parent.  Note that the only time
> oom_kill_task() fails, however, is when a child does not have an mm or
> has a /proc/pid/oom_adj of OOM_DISABLE.  badness() returns 0 for both
> cases, so the final oom_kill_task() will always succeed.
>
> Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Regardless of forkbom detection, It does makes sense to me.

-- 
Kind regards,
Minchan Kim

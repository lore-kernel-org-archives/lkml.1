Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYB1AuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYB1AuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbYB1At6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:49:58 -0500
Received: from smtp-out.google.com ([216.239.45.13]:2364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbYB1At5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:49:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=DuoM3OiaXUlj6M+3Fb+qJ4k22769uBapt7k/uBL5PS5UCrs4I8Le4EKG3pUaKuLOc
	ITRT5gwBpmDRmyJu7kFYg==
Message-ID: <6599ad830802271649h29a13ceevf2255dd6235b42ba@mail.gmail.com>
Date: Wed, 27 Feb 2008 16:49:44 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] cpuset: fix return value of cpuset_populate()
Cc: "Li Zefan" <lizf@cn.fujitsu.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080227014135.0c361ab3.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47C5131A.80508@cn.fujitsu.com>
	 <20080227014135.0c361ab3.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 11:41 PM, Paul Jackson <pj@sgi.com> wrote:
>
>  - no need to check err == 0
>  - the last return value of cgroup_add_file() is ignored
>
>  Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Looks fine from a cleanliness PoV, although since we don't actually do
anything with an error result from subsys->populate() (a behaviour
that I sort of inherited from cpusets ...) it won't make a whole lot
of difference to the code.

A better change would be to make cpuset_populate() use cgroup_add_files().

Paul

>  ---
>   kernel/cpuset.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
>  diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>  index 3e296ed..1c5b2d2 100644
>  --- a/kernel/cpuset.c
>  +++ b/kernel/cpuset.c
>  @@ -1482,10 +1482,10 @@ static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
>         if ((err = cgroup_add_file(cont, ss, &cft_spread_slab)) < 0)
>                 return err;
>         /* memory_pressure_enabled is in root cpuset only */
>  -       if (err == 0 && !cont->parent)
>  +       if (!cont->parent)
>                 err = cgroup_add_file(cont, ss,
>                                          &cft_memory_pressure_enabled);
>  -       return 0;
>  +       return err;
>   }
>
>   /*
>  --
>  1.5.4.rc3
>
>
>  --
>                   I won't rest till it's the best ...
>                   Programmer, Linux Scalability
>                   Paul Jackson <pj@sgi.com> 1.940.382.4214
>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYCJVBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYCJVBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYCJVBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:01:46 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45668 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbYCJVBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:01:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=X2rQE2GrP2iwsEP3uh2JMAy2ZejZ0RV0iHpzxlMT7lqSOVs0oTMGpCtR8pI5Ce5Um
	TQfiS4GmexMyCC5jORQ2g==
Message-ID: <6599ad830803101401s3b12bc85l53ef67f083ad761c@mail.gmail.com>
Date: Mon, 10 Mar 2008 14:01:33 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] cgroup: switch to proc_create()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47D4E3AC.2020600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D4E3AC.2020600@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 12:30 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> There is a race between create_proc_entry() and the assignment
>  of file ops. proc_create() is invented to fix it.
>
>  Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Doesn't seem to be a serious race since there's nothing in userspace
at this point to read the file. But replacing four lines with one is
generally a good thing.

Paul

>  ---
>   kernel/cgroup.c |    5 +----
>   1 files changed, 1 insertions(+), 4 deletions(-)
>
>  diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>  index 8d833b6..8d45126 100644
>  --- a/kernel/cgroup.c
>  +++ b/kernel/cgroup.c
>  @@ -2489,7 +2489,6 @@ int __init cgroup_init(void)
>   {
>         int err;
>         int i;
>  -       struct proc_dir_entry *entry;
>
>         err = bdi_init(&cgroup_backing_dev_info);
>         if (err)
>  @@ -2505,9 +2504,7 @@ int __init cgroup_init(void)
>         if (err < 0)
>                 goto out;
>
>  -       entry = create_proc_entry("cgroups", 0, NULL);
>  -       if (entry)
>  -               entry->proc_fops = &proc_cgroupstats_operations;
>  +       proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations);
>
>   out:
>         if (err)
>  --
>  1.5.4.rc3
>

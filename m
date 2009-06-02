Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbZFBH7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbZFBH7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758602AbZFBH7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:59:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:20055 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663AbZFBH7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:59:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=kDqf4iavjmM9xoJ0Zrhgu2SnG58hZJ5Sg632kvPv8D6VdqLudsPnDShh4/FghaYQ4
	QLK+gkYslrRbB6I+SkhXQ==
MIME-Version: 1.0
In-Reply-To: <4A24911F.4070601@cn.fujitsu.com>
References: <4A24911F.4070601@cn.fujitsu.com>
Date: Tue, 2 Jun 2009 00:59:31 -0700
Message-ID: <6599ad830906020059r6aa7e8f5ra7e570e70360f100@mail.gmail.com>
Subject: Re: [PATCH] cgroups: forbid noprefix if mounting more than just 
	cpuset subsystem
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 1, 2009 at 7:40 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> We don't want users to use nopreifx, and also want to avoid name
> collision, so we change to allow noprefix only if mounting just
> the cpuset subsystem.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index a7267bf..ad17f9d 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -842,6 +842,11 @@ static int parse_cgroupfs_options(char *data,
>                                     struct cgroup_sb_opts *opts)
>  {
>        char *token, *o = data ?: "all";
> +       unsigned long mask = (unsigned long)-1;

Patch looks good, but to make it more self-explanatory how about
calling this variable noprefix_conflict_mask ?

Paul

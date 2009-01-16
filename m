Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbZAPEe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbZAPEe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762624AbZAPEeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:34:36 -0500
Received: from smtp-out.google.com ([216.239.33.17]:46941 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761300AbZAPEef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:34:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=H1HKkb+b7YjN9GVLX4jLn4KbnClrILOHkNc5ty8aUFB1ygthZgbNbH/1qyfL41esf
	BPyM98j8iZGI/3KIrhlIg==
MIME-Version: 1.0
In-Reply-To: <20090116121725.fff7dad9.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090116121725.fff7dad9.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 15 Jan 2009 20:34:28 -0800
Message-ID: <6599ad830901152034i4ffb7d24mbd5ab35d41cc7deb@mail.gmail.com>
Subject: Re: [PATCH] use hierarchy mutex in creation failure path
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       containers@lists.linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.88
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 7:17 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Now, cgrp->sibling is handled under hierarchy mutex.
> error route should do so, too.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by Paul Menage <menage@google.com>

Good catch, thanks.

Paul

>
> ---
>  kernel/cgroup.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> Index: mmotm-2.6.29-Jan14/kernel/cgroup.c
> ===================================================================
> --- mmotm-2.6.29-Jan14.orig/kernel/cgroup.c
> +++ mmotm-2.6.29-Jan14/kernel/cgroup.c
> @@ -2434,7 +2434,9 @@ static long cgroup_create(struct cgroup
>
>  err_remove:
>
> +       cgroup_lock_hierarchy(root);
>        list_del(&cgrp->sibling);
> +       cgroup_unlock_hierarchy(root);
>        root->number_of_cgroups--;
>
>  err_destroy:
>
>

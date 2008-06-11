Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYFKHp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYFKHp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 03:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYFKHps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 03:45:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:1849 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYFKHpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 03:45:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ywAzNZkW6fLJyqJkGd8TzmgnhzksekYBU0obLwKzqvJLL6QXQlf4UKAXcE12KSuHY
	RMSV2yDl8DXvya31OI45A==
Message-ID: <6599ad830806110045n6aec52ddkfb4be91b685357fe@mail.gmail.com>
Date: Wed, 11 Jun 2008 00:45:43 -0700
From: "Paul Menage" <menage@google.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] introduce task cgroup v2
Cc: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       "Li Zefan" <lizf@cn.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080607195733.9C77.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080607195733.9C77.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 4:00 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> +
> +#include <linux/cgroup.h>
> +#include <linux/err.h>
> +#include <linux/cgroup_task.h>
> +
> +struct task_cgroup {
> +       struct cgroup_subsys_state css;
> +       /*
> +        * the counter to account for number of thread.
> +        */
> +       int max_tasks;
> +       int nr_tasks;
> +
> +       spinlock_t lock;
> +};

This looks rather like a res_counter. Can you resuse that rather than
implementing your own read/write/charge/uncharge routines?

Paul

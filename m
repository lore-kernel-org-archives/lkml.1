Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYKUR7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYKUR7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbYKUR7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:59:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:10795 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbYKUR7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:59:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=SeIR7M03Hhp70jCHu/m5VX+T3JZI3qsFTwqs6DS/gdHsLEZmQ036tWaivIbF/F9RO
	BKaQtsq4Wqz/oldK7VcSQ==
MIME-Version: 1.0
In-Reply-To: <4926760C.3040005@cn.fujitsu.com>
References: <4926760C.3040005@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 09:59:05 -0800
Message-ID: <6599ad830811210959t22e0fe1ck33828f762a3bfdbd@mail.gmail.com>
Subject: Re: [PATCH] cgroups: add lock for child->cgroups in 
	cgroup_post_fork()
From: Paul Menage <menage@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 12:49 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> when cgroup_post_fork() called, child is seen by find_task_by_vpid(),
> so child->cgroups maybe be changed, It'll incorrect.
>
> child->cgroups<old>'s refcnt is decreased
> child->cgroups<new>'s refcnt is increased
> but child->cg_list is added to child->cgroups<old>'s list.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Reviewed-by: Paul Menage <menage@google.com>

Yeah, I guess this was a place where I equated "holding css_set_lock"
with "cgroups can't change". But in fact they can partially change.

Paul

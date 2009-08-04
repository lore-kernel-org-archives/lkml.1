Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZHDBzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZHDBzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 21:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZHDBzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 21:55:24 -0400
Received: from smtp-out.google.com ([216.239.45.13]:3966 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbZHDBzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 21:55:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=UKEt4sJEV00swadm1ovtWp/G6QY1TmvwGOtYAG2a1fx4KbAnIYU5k963CD4barZO9
	xezbx13Hn+tVD93B9n3kw==
MIME-Version: 1.0
In-Reply-To: <4A7792C4.5010504@cn.fujitsu.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>
	 <4A7652E7.4020206@cn.fujitsu.com>
	 <2f86c2480908031756j557e7aebmbf7951da6a1aadb0@mail.gmail.com>
	 <4A778A49.6040302@cn.fujitsu.com>
	 <2f86c2480908031819h2513cdb4tac3d6def3e0aa320@mail.gmail.com>
	 <4A7792C4.5010504@cn.fujitsu.com>
Date: Mon, 3 Aug 2009 18:55:20 -0700
Message-ID: <6599ad830908031855t3ad772e4w4c52e5d7bf4d2508@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Benjamin Blum <bblum@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 6:45 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>
> No. Note task exiting is not protected by cgroup_lock, so this can
> happen:
>
>                               | cgroup_attach_task()
>                               |   oldcg = tsk->cgroups;
>                               |   (tasks->flags & TASK_EXISING == 0)
>                               |   rcu_assign_pointer(tsk->cgroups, newcg);
> cgroup_exit()                  |
>  oldcg = tsk->cgroups;        |
>  put_css_set_taskexit(oldcg); |
>  (now ref of olcg is 0)       |
>                               |   put_css_set(oldcg);
>

But in both cases, reading tsk->cgroups occurs with task->alloc_lock held.

Paul

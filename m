Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbZHUUu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbZHUUu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547AbZHUUu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:50:57 -0400
Received: from smtp-out.google.com ([216.239.45.13]:29177 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbZHUUu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:50:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=E9tDlmJxH8odzj6OQwAy627B0KshC+dRQoSzbVbrcFOy3YGFD5pXTw5NCSCe1DWaD
	Gx4TrwNwiQqO4shqCIATg==
MIME-Version: 1.0
In-Reply-To: <20090821103813.GA27473@darkstar>
References: <200908210222.n7L2Musb015815@imap1.linux-foundation.org>
	 <20090821103813.GA27473@darkstar>
Date: Fri, 21 Aug 2009 13:50:55 -0700
Message-ID: <6599ad830908211350j7d4a4475kba1860b4368efe3c@mail.gmail.com>
Subject: Re: mmotm 2009-08-20-19-18 uploaded
From: Paul Menage <menage@google.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 3:38 AM, Dave Young<hidave.darkstar@gmail.com> wrote:
> Hi andrew
>
> cgroup build fail:
>
> kernel/sched.c:10452: error: expected ';', ',' or ')' before 'bool'
> kernel/sched.c:10536: error: 'cpu_cgroup_attach' undeclared here (not in a function)
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2
> make: *** Waiting for unfinished jobs....
>
> fixing:
> --
>
> --- linux-2.6.orig/kernel/sched.c       2009-08-21 18:08:16.000000000 +0800
> +++ linux-2.6/kernel/sched.c    2009-08-21 18:20:03.000000000 +0800
> @@ -10448,7 +10448,7 @@ cpu_cgroup_can_attach(struct cgroup_subs
>
>  static void
>  cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
> -                 struct cgroup *old_cont, struct task_struct *tsk
> +                 struct cgroup *old_cont, struct task_struct *tsk,
>                  bool threadgroup)

Ah, sorry, it looks as though CONFIG_CGROUP_SCHED got turned off in my
config (and Ben's, apparently) so this function was never actually
compiled.

Paul

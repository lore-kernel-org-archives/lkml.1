Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbYDBK0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbYDBK0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYDBK0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:26:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39989 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYDBK0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:26:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=gFlrwm41prhsoy/3tZlDMls8dt1b2c335ZbORPB+IbdOXEITBi4bBiZcMX5gB/BVp
	UK6IVeLDZmH1BJYRHoqQw==
Message-ID: <6599ad830804020326o7947e3e5k25249e6b1c00e6b5@mail.gmail.com>
Date: Wed, 2 Apr 2008 03:26:24 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH -mm 2/3] cgroup: simplify init_subsys()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
In-Reply-To: <47F2EC94.8030707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F2EC94.8030707@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2008 at 7:16 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>  -
>  -       /* If this subsystem requested that it be notified with fork
>  -        * events, we should send it one now for every process in the
>  -        * system */
>  -       if (ss->fork) {
>  -               struct task_struct *g, *p;
>  -
>  -               read_lock(&tasklist_lock);
>  -               do_each_thread(g, p) {
>  -                       ss->fork(ss, p);
>  -               } while_each_thread(g, p);
>  -               read_unlock(&tasklist_lock);
>  -       }

Should we maybe call ss->fork(ss, &init_task) ? Or just document that
ss->fork() explicitly doesn't get called for init.

Maybe also add some BUG()s to confirm that no other tasks have in fact
been forked by this point?

Paul

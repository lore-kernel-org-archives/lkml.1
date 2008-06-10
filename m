Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbYFJRlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbYFJRlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYFJRld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:41:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50076 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbYFJRlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:41:32 -0400
Subject: Re: [RFC PATCH 5/5] refresh VM committed space after a task
	migration
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
In-Reply-To: <1213054383-18137-6-git-send-email-righi.andrea@gmail.com>
References: <>  <1213054383-18137-6-git-send-email-righi.andrea@gmail.com>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 10:41:28 -0700
Message-Id: <1213119688.13882.13.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 01:33 +0200, Andrea Righi wrote:
> +       preempt_disable();
> +       committed = atomic_long_read(&p->vm_committed_space);
> +       atomic_long_sub(committed, &old_mem->vmacct.vm_committed_space);
> +       atomic_long_add(committed, &mem->vmacct.vm_committed_space);
> +       preempt_enable();
>  out:
>         mmput(mm);
>  }

Why bother with the preempt stuff here?  What does the actually protect
against?  I assume that you're trying to keep other tasks that might run
on this CPU from seeing weird, inconsistent numbers in here.  Is there
some other looks that keeps *other* cpus from seeing this?

In any case, I think it needs a big, fat comment.

-- Dave


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZALXP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZALXP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbZALXPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:15:11 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:52543 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZALXPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:15:10 -0500
Date: Mon, 12 Jan 2009 17:14:52 -0600
From: Nathan Lynch <ntl@pobox.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v12][PATCH 13/14] Checkpoint multiple processes
Message-ID: <20090112231452.GC6850@localdomain>
References: <1230542187-10434-1-git-send-email-orenl@cs.columbia.edu>
 <1230542187-10434-14-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230542187-10434-14-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: DAEB6AD8-E0FE-11DD-9C06-5720C92D7133-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* count number of tasks in tree (and optionally fill pid's in array) */
> +static int cr_tree_count_tasks(struct cr_ctx *ctx)
> +{
> +	struct task_struct *root = ctx->root_task;
> +	struct task_struct *task = root;
> +	struct task_struct *parent = NULL;
> +	struct task_struct **tasks_arr = ctx->tasks_arr;
> +	int tasks_nr = ctx->tasks_nr;
> +	int nr = 0;
> +
> +	read_lock(&tasklist_lock);
> +
> +	/* count tasks via DFS scan of the tree */
> +	while (1) {
> +		if (tasks_arr) {
> +			/* unlikely, but ... */
> +			if (nr == tasks_nr)
> +				return -EBUSY;	/* cleanup in cr_ctx_free() */

Returns without unlocking tasklist_lock?



Return-Path: <linux-kernel-owner+w=401wt.eu-S1765345AbZANR2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765345AbZANR2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764186AbZANR1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:27:52 -0500
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:63958 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763804AbZANR1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:27:50 -0500
Message-ID: <496E206A.6020003@cs.columbia.edu>
Date: Wed, 14 Jan 2009 12:27:06 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Nathan Lynch <ntl@pobox.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v12][PATCH 13/14] Checkpoint multiple processes
References: <1230542187-10434-1-git-send-email-orenl@cs.columbia.edu> <1230542187-10434-14-git-send-email-orenl@cs.columbia.edu> <20090112231452.GC6850@localdomain>
In-Reply-To: <20090112231452.GC6850@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Nathan Lynch wrote:
>> +/* count number of tasks in tree (and optionally fill pid's in array) */
>> +static int cr_tree_count_tasks(struct cr_ctx *ctx)
>> +{
>> +	struct task_struct *root = ctx->root_task;
>> +	struct task_struct *task = root;
>> +	struct task_struct *parent = NULL;
>> +	struct task_struct **tasks_arr = ctx->tasks_arr;
>> +	int tasks_nr = ctx->tasks_nr;
>> +	int nr = 0;
>> +
>> +	read_lock(&tasklist_lock);
>> +
>> +	/* count tasks via DFS scan of the tree */
>> +	while (1) {
>> +		if (tasks_arr) {
>> +			/* unlikely, but ... */
>> +			if (nr == tasks_nr)
>> +				return -EBUSY;	/* cleanup in cr_ctx_free() */
> 
> Returns without unlocking tasklist_lock?
> 

Thanks. Will fix.

Oren.

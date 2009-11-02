Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbZKBErS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbZKBErS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 23:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZKBErR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 23:47:17 -0500
Received: from ozlabs.org ([203.10.76.45]:54926 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbZKBErR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 23:47:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19182.22220.389174.916544@cargo.ozlabs.ibm.com>
Date: Mon, 2 Nov 2009 14:49:32 +1100
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 3/6] perf/core: Add a callback to perf events
In-Reply-To: <1257109753-6464-4-git-send-email-fweisbec@gmail.com>
References: <4AE55B1B.2030006@web.de>
	<1257109753-6464-4-git-send-email-fweisbec@gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker writes:

> @@ -4335,6 +4336,15 @@ perf_event_alloc(struct perf_event_attr *attr,
>  
>  	event->state		= PERF_EVENT_STATE_INACTIVE;
>  
> +	if (!callback) {
> +		if (parent_event)
> +			event->callback = parent_event->callback;
> +		else
> +			event->callback = NULL;
> +	} else {
> +		event->callback		= callback;
> +	}

Wouldn't this be simpler and clearer as:

	if (!callback && parent_event)
		callback = parent_event->callback;
	event->callback = callback;

?

Paul.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbZAFWxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbZAFWxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbZAFWx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:53:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381AbZAFWx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:53:26 -0500
Date: Tue, 6 Jan 2009 14:51:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       roel.kluin@gmail.com, pq@iki.fi, srostedt@redhat.com
Subject: Re: [PATCH 3/3] tracing/ftrace: fix a memory leak in stat tracing
Message-Id: <20090106145157.124e910f.akpm@linux-foundation.org>
In-Reply-To: <20090106223405.703770821@goodmis.org>
References: <20090106223337.677427397@goodmis.org>
	<20090106223405.703770821@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2009 17:33:40 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

>  static int stat_seq_show(struct seq_file *s, void *v)
>  {
> -	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
> -	return current_tracer.stat_show(s, l->stat);
> +	struct trace_stat_list *entry =
> +		list_entry(v, struct trace_stat_list, list);
> +
> +	return current_tracer.stat_show(s, entry->stat);
>  }

Rather than jumping through weird 80-column hoops, one can just do:

	struct trace_stat_list *entry;

	...

	entry = list_entry(v, struct trace_stat_list, list);


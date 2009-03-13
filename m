Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbZCMFV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbZCMFV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZCMFVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:21:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517AbZCMFVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:21:17 -0400
Date: Thu, 12 Mar 2009 22:16:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/4] tracing: move binary buffers into per cpu directory
Message-Id: <20090312221634.407c82ad.akpm@linux-foundation.org>
In-Reply-To: <20090313050521.535041167@goodmis.org>
References: <20090313050446.277065036@goodmis.org>
	<20090313050521.535041167@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009 01:04:49 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

>  	if (!entry)
>  		pr_warning("Could not create debugfs 'trace' entry\n");
> +
> +	entry = debugfs_create_file("trace_pipe_raw", 0444, d_cpu,
> +				    (void *) cpu, &tracing_buffers_fops);
> +	if (!entry)
> +		pr_warning("Could not create debugfs 'trace_pipe_raw' entry\n");

Maybe we should just do the warning in debugfs_create_file().  It's hard to
think of a scenario where we wouldn't want this failure to be reported.

If there is such a scenario then debugfs_create_file_nowarn() beckons.

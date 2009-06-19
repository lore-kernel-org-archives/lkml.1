Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZFSIU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZFSIU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 04:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZFSIUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 04:20:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62045 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZFSIUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 04:20:44 -0400
Message-ID: <4A3B4AC5.5050107@cn.fujitsu.com>
Date: Fri, 19 Jun 2009 16:22:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, bligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 1/7] add syscall tracepoints
References: <cover.1244837725.git.jbaron@redhat.com> <bfe6d2004c9878b127449bb20855001e10fb644d.1244837725.git.jbaron@redhat.com>
In-Reply-To: <bfe6d2004c9878b127449bb20855001e10fb644d.1244837725.git.jbaron@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int syscall_name_to_nr(char *name)
> +{
> +	int i;
> +
> +	if (!syscalls_metadata)
> +		return -1;
> +
> +	for (i = 0; i < FTRACE_SYSCALL_MAX; i++) {
> +		if (syscalls_metadata[i]) {
> +			if (!strcmp((syscalls_metadata[i])->name, name))

Remove a pair of parenthesis looks cleaner:

			if (!strcmp(syscalls_metadata[i]->name, name))

> +				return i;
> +		}
> +	}
> +	return -1;
> +}
> +
>  void arch_init_ftrace_syscalls(void)
>  {
>  	int i;



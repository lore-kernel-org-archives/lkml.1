Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbXLHEB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbXLHEB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 23:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbXLHEBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 23:01:19 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60931 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbXLHEBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 23:01:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zan Lynx <zlynx@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc4-mm1 and /proc/<pid>/status Name: field
References: <1197059203.15428.5.camel@localhost>
	<20071207155816.25a00c41.akpm@linux-foundation.org>
Date: Fri, 07 Dec 2007 20:59:55 -0700
In-Reply-To: <20071207155816.25a00c41.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 7 Dec 2007 15:58:16 -0800")
Message-ID: <m1wsrpq1j8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 07 Dec 2007 20:26:43 +0000
> Zan Lynx <zlynx@acm.org> wrote:
>
>> Today I noticed pgrep doesn't work.  It seems the reason is a missing
>> Name: tag in the status file for a process in /proc.
>> 
>> # cat /proc/1/status
>> init
>> State:  S (sleeping)
>> Tgid:   1
>> Pid:    1
>> PPid:   0
>> TracerPid:      0
>> ...etc, etc...
>> 
>> This is supposed to look like:
>> # cat /proc/1/status
>> Name:	init
>> State:	S (sleeping)
>> Tgid:	1
>> Pid:	1
>> PPid:	0
>> TracerPid:	0
>> ...
>> 
>
> Thanks.  Two (more) bugs in
> proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch

Doh!  How did I get that one confused?

Thanks.
Eric


>
> ---
> a/fs/proc/array.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3
> +++ a/fs/proc/array.c
> @@ -98,9 +98,9 @@ static inline void task_name(struct seq_
>  
>  	get_task_comm(tcomm, p);
>  
> +	seq_printf(m, "Name:\t");
>  	end = m->buf + m->size;
>  	buf = m->buf + m->count;
> -	seq_printf(m, "Name:\n");
>  	name = tcomm;
>  	i = sizeof(tcomm);
>  	while (i && (buf < end)) {
> _

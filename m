Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbZGUXbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbZGUXbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 19:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZGUXbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 19:31:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:38673 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbZGUXbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 19:31:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=AexfXIgCRUJm+L5PwKIwGMYgidk5L6zBOiSiSPNqBuX1uql95dlBGyivQaS+LIPrM
	t1CpEBnVoIyZAH/H1HJ/A==
MIME-Version: 1.0
In-Reply-To: <4A4DB9E4.9060500@cn.fujitsu.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	 <20090702021113.14469.2703.stgit@menage.mtv.corp.google.com>
	 <4A4DB9E4.9060500@cn.fujitsu.com>
Date: Tue, 21 Jul 2009 16:31:00 -0700
Message-ID: <6599ad830907211631g6fb363d1n147fc0843fa4e626@mail.gmail.com>
Subject: Re: [PATCH 4/9] [RFC] Allow cgroup hierarchies to be created with no 
	bound subsystems
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, updated for the next version of these patches.

Thanks,

Paul

On Fri, Jul 3, 2009 at 12:57 AM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>> +#define MAX_TASKS_SHOWN_PER_CSS 25
>> +static int cgroup_css_links_read(struct cgroup *cont,
>> +                              struct cftype *cft,
>> +                              struct seq_file *seq)
>> +{
>> +     struct cg_cgroup_link *link, *saved_link;
>
> need a newline
>
>> +     write_lock_irq(&css_set_lock);
>
> can be read_lock(&css_set_lock);
>
>> +     list_for_each_entry_safe(link, saved_link, &cont->css_sets,
>
> can be list_for_each_entry()
>
>> +                              cgrp_link_list) {
>> +             struct css_set *cg = link->cg;
>> +             struct task_struct *task, *saved_task;
>> +             int count = 0;
>> +             seq_printf(seq, "css_set %p\n", cg);
>> +             list_for_each_entry_safe(task, saved_task, &cg->tasks,
>
> ditto
>
>> +                                      cg_list) {
>> +                     if (count++ > MAX_TASKS_SHOWN_PER_CSS) {
>> +                             seq_puts(seq, "  ...\n");
>> +                             break;
>> +                     } else {
>> +                             seq_printf(seq, "  task %d\n",
>> +                                        task_pid_vnr(task));
>> +                     }
>> +             }
>> +     }
>> +     write_unlock_irq(&css_set_lock);
>> +     return 0;
>> +}
>

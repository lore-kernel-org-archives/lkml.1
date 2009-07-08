Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbZGHAzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbZGHAzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 20:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZGHAzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 20:55:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64706 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755296AbZGHAzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 20:55:41 -0400
Message-ID: <4A53EE88.1080003@cn.fujitsu.com>
Date: Wed, 08 Jul 2009 08:55:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] ksym_tracer: Extract trace entry from struct	trace_ksym
References: <4A52E291.1020408@cn.fujitsu.com> <4A52E2A4.4050007@cn.fujitsu.com> <20090707212520.GA7412@nowhere>
In-Reply-To: <20090707212520.GA7412@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -	entry = ring_buffer_event_data(event);
>> +	entry		= ring_buffer_event_data(event);
>> +	entry->ip	= instruction_pointer(regs);
>> +	entry->type	= hbp->info.type;
>>  	strlcpy(entry->ksym_name, hbp->info.name, KSYM_SYMBOL_LEN);
>> -	entry->ksym_hbp = hbp;
>> -	entry->ip = instruction_pointer(regs);
>> -	strlcpy(entry->p_name, current->comm, TASK_COMM_LEN);
>> +	strlcpy(entry->cmd, current->comm, TASK_COMM_LEN);
> 
> 
> Ah, I did not realized that the cmdline was that roughly saved.
> It would be more ring-buffer-friendly to use tracing_record_cmdline.
> 

Yeah, I'll send an incremental patch later.

> 

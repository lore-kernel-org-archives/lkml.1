Return-Path: <linux-kernel-owner+w=401wt.eu-S1752422AbZC3Kog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbZC3Kog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 06:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZC3Ko1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 06:44:27 -0400
Received: from mga12.intel.com ([143.182.124.36]:56683 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751009AbZC3Ko0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 06:44:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,446,1233561600"; 
   d="scan'208";a="125588567"
Message-ID: <49D0A29E.2040406@linux.intel.com>
Date: Mon, 30 Mar 2009 12:44:46 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
CC: Oleg Nesterov <oleg@redhat.com>,
       Markus Metzger <markus.t.metzger@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Subject: Re: [patch 3/14] x86, ptrace, bts: stop bts tracing early in	do_exit
References: <20090327095525.A11052@sedona.ch.intel.com> <20090327143435.GD14504@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E9266B6D4@irsmsx504.ger.corp.intel.com> <20090327172413.GC25762@redhat.com> <1238239912.6036.0.camel@raistlin> <20090330012204.GA2058@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E9266B8A9@irsmsx504.ger.corp.intel.com>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E9266B8A9@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
>>> ds_release_bts(struct bts_tracer *tracer)
>>> {
>>> 	struct task_struct *task =
>>> 		tracer->ds.context->task;
>>>
>>> 	do {
>>> 		set_task_state(task, TASK_UNINTERRUPTIBLE);
>> Oh, this is not right,
> 
> Agreed.
> 
> I wonder if it is ever safe to change another task's state.
> There's a lot of code that sets the task state seemingly
> unprotected - but always for current.

It should be safe when you can guarantee that the other task is stopped
(as in ptrace) and you protect against yourself (only a single
external writer)

-Andi

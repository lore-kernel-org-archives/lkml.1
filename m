Return-Path: <linux-kernel-owner+w=401wt.eu-S933036AbXLMVbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbXLMVbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763667AbXLMVbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:31:15 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52980 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbXLMVbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:31:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Mark timer_stats as incompatible with multiple pid namespaces
References: <m13au7tsov.fsf@ebiederm.dsl.xmission.com>
	<20071213090102.GB1926@elte.hu>
	<m1r6hqstat.fsf@ebiederm.dsl.xmission.com>
	<20071213130423.GB28340@elte.hu>
	<m1ir32sejc.fsf@ebiederm.dsl.xmission.com>
	<20071213202621.GC25130@elte.hu>
Date: Thu, 13 Dec 2007 14:29:09 -0700
In-Reply-To: <20071213202621.GC25130@elte.hu> (Ingo Molnar's message of "Thu,
	13 Dec 2007 21:26:21 +0100")
Message-ID: <m1prxaqo62.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> > the problem is, this interface stores historic PIDs too - i.e. PIDs 
>> > of tasks that might have exited already.
>> 
>> Well struct pid * works in that case if you grab the reference to it.
>
> but the display of the stats might happen much later. The point of this 
> API is to save pid+comm, which gives users a good idea about what caused 
> the events in the past - without having to pin any resource of that 
> task.

Likewise struct pid is designed not to be a problem if pinned. It is a
little heavier then it used to be with the addition of pid namespace
support but not much.  And if it is to heavy struct pid needs to be
fixed.

Holding the struct pid very much does not pin the task struct, and it
shouldn't pin any other resources.  I agree 64bytes or so is a bit
more to pin then 4 bytes but it really isn't a lot.

>>  {
>>  	timer->start_site = NULL;
>> +	pit_pid(timer->start_pid);
>> +	timer->start_pid = NULL;
>
> s/pit/put, right?

Yes.  Clearly I haven't tested it yet.

Eric



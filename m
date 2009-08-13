Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZHMP5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZHMP5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbZHMP5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:57:19 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:34284 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286AbZHMP5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:57:19 -0400
Message-ID: <4A8437DC.8080509@parrot.com>
Date: Thu, 13 Aug 2009 17:57:16 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Ingo Molnar <mingo@elte.hu>,
       "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [ltt-dev] Tracing thread name
References: <4A76E42D.7010908@parrot.com> <20090803134843.GB23455@Krystal>	<4A78099B.4@parrot.com> <20090804130510.GA23396@Krystal> <4A784056.1020400@parrot.com>
In-Reply-To: <4A784056.1020400@parrot.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthieu CASTET a écrit :
> Hi,
> 
> Mathieu Desnoyers a écrit :
>> * Matthieu CASTET (matthieu.castet@parrot.com) wrote:
>>> Hi Mathieu,
>>>
>>> Mathieu Desnoyers a écrit :
>>> Do you know if it is possible to patch my version to add such feature ?
>>>
>>> I saw that the name already change in the trace before/after an exec.
>>> How lltv get the new name ?
>>> With "fs.exec" tracepoint ?
>>> In that case I could fake a "fs.exec" tracepoint in set_task_comm.
>> A better solution : you add a new event in both lttng and lttv, and
>> modify state.c to support your new event. The current event to brand
>> thread is named "userspace.thread_brand". Look for this in LTTV to see
>> all the sites that need to support the new event (there are very few).
>>
> Thanks, but I want to avoid to modify too much ltt (I use an old version
> for 2.6.27 and my modifications may be useless for upstream).
> 
> I added "trace_fs_exec(tsk->comm);" at the end of set_task_comm and now
> the thread got the correct name :)
> 
BTW it is also interesting to get the name of the kernel threads
(created by kthread_create).
The current version of ltt show "kthreadd" for these threads.

The same solution than set_task_comm should solve the problem (comm is
set at the end of kthread_create).


Matthieu

PS: khelper thread are also annoying because they all got the same name.
May be it could be interesting to add extra info in the name.


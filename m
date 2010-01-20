Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080Ab0ATTcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab0ATTcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768Ab0ATTcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:32:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab0ATTcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:32:13 -0500
Message-ID: <4B575A1C.6010206@redhat.com>
Date: Wed, 20 Jan 2010 14:31:40 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Jim Keniston <jkenisto@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <4B544F8E.1080603@redhat.com> <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com> <4B545146.3080001@redhat.com> <20100118124419.GC1628@linux.vnet.ibm.com> <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com> <4B5459CA.9060603@redhat.com> <4B545ACF.40203@cs.helsinki.fi> <1263852957.2266.38.camel@localhost.localdomain> <4B556855.6040800@redhat.com> <1263923265.4998.28.camel@localhost.localdomain> <20100119180610.GA11005@nowhere>
In-Reply-To: <20100119180610.GA11005@nowhere>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Jan 19, 2010 at 09:47:45AM -0800, Jim Keniston wrote:
>>> Do you have plans for a variant 
>>> that's completely in userspace?
>>
>> I don't know of any such plans, but I'd be interested to read more of
>> your thoughts here.  As I understand it, you've suggested replacing the
>> probed instruction with a jump into an instrumentation vma (the XOL
>> area, or something similar).  Masami has demonstrated -- through his
>> djprobes enhancement to kprobes -- that this can be done for many x86
>> instructions.
>>
>> What does the code in the jumped-to vma do?  Is the instrumentation code
>> that corresponds to the uprobe handlers encoded in an ad hoc .so?
> 
> 
> Once the instrumentation is requested by a process that is not the
> instrumented one, this looks impossible to set a uprobe without a
> minimal voluntary collaboration from the instrumented process
> (events sent through IPC or whatever). So that looks too limited,
> this is not anymore a true dynamic uprobe.

Agreed. Since uprobe's handler must be running in kernel,
we need to jump into kernel space anyway. "Booster" (just skips
a single-stepping(trap) exception) may be useful for
improving uprobe performance.

And also as Andi said, using jump instead of int3 in userspace
has 2GB address space limitation. It's not a problem for kernel
inside, but a big problem in userspace.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


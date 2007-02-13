Return-Path: <linux-kernel-owner+w=401wt.eu-S1751215AbXBMJVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbXBMJVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXBMJVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:21:52 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:7326 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbXBMJVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:21:51 -0500
Message-ID: <45D1825A.7070907@sw.ru>
Date: Tue, 13 Feb 2007 12:18:18 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 6/7] containers (V7): BeanCounters over generic process
 containers
References: <20070212081521.808338000@menage.corp.google.com>	 <20070212085104.998727000@menage.corp.google.com>	 <45D17C48.9030105@sw.ru> <6599ad830702130103l54f48df0y7c20606d31122a50@mail.gmail.com>
In-Reply-To: <6599ad830702130103l54f48df0y7c20606d31122a50@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 2/13/07, Pavel Emelianov <xemul@sw.ru> wrote:
>> menage@google.com wrote:
>> > This patch implements the BeanCounter resource control abstraction
>> > over generic process containers. It contains the beancounter core
>> > code, plus the numfiles resource counter. It doesn't currently contain
>> > any of the memory tracking code or the code for switching beancounter
>> > context in interrupts.
>>
>> Numfiles is not the most interesting place in beancounters.
>> Kmemsize accounting is much more important actually.
> 
> Right, but the memory accouting was a much bigger and more intrusive
> patch than I wanted to include as an example.

I know it, but numfile doesn't show how good this
infrastructure is.

>>
>> I have already pointed out the fact that this place
>> will hurt performance too much. If we have some context
>> on task this context must
>>   1. be get-ed without any locking
> 
> Would you also be happy with the restriction that a task couldn't be
> moved in/out of a beancounter container by any task other than itself?

I have implementation that moves arbitrary task :)
May be we can do context (container-on-task) handling lockless?

> If so, the beancounter can_attach() method could simply return false
> if current != tsk, and then you'd not need to worry about locking in
> this situation.

I may not, but this patch contains locking that is not good
even for example.

>>   2. be settable to some temporary one without
>>      locking as well
> 
> I thought that we solved that problem by having a tmp_bc field in the
> task_struct that would take precedence over the main bc if it was
> non-null?

Of course, but I'm commenting this patchset which doesn't have
this facility.

> Paul
> 


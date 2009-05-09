Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbZEIOsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbZEIOsC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:48:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbZEIOrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:47:51 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48616 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZEIOru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NA9X3uG8q6zsAXlREdeEcFhna9bejDozeekdy4vxSyTVymCEstH+SXOVnD8bzIt2bA
         TXeJbtzq6qZjbx1LWiV+RyQvQLiW3bhu3yxEDVj2Fxi9a5+ktxzfBokq4jEd3PBOI+s6
         lzHbT42hM4wWiAYp72vDXrD/WKi5Kt4YdhNeI=
MIME-Version: 1.0
In-Reply-To: <20090509141556.GA24082@elte.hu>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu>
	 <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com>
	 <20090509133306.GA20684@elte.hu> <20090509135046.GA2344@Krystal>
	 <c62985530905090706t52929c0qe21418f86aca9ba8@mail.gmail.com>
	 <20090509141556.GA24082@elte.hu>
Date: Sat, 9 May 2009 16:47:48 +0200
Message-ID: <c62985530905090747y14629237p2ad9ea5b10ce0126@mail.gmail.com>
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       roland@redhat.com, fche@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 9 mai 2009 16:15, Ingo Molnar <mingo@elte.hu> a écrit :
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> > I would expect to use copy_string_from_user (for strings) and
>> > copy_from_user for structures, because without any strings
>> > (especially), the trace information become much less useful.
>>
>> Yeah, for structures we would just need the copy_from_user.
>
> There's just a few places (mainly related to VFS APIs) where we
> really want to do that, and there we want to do it a bit later, not
> at syscall time: we want to do it after the getname(), to output a
> stable (and already copied to kernel space) copy of the file name.
>
> So the right solution there would be to add special, case by case
> tracepoints to those few places. We dont need strings for the
> majority of the 300+ system calls that exist on Linux.



Yeah, let's start with something generic. We'll be able to treat the particular
cases later, using types encoding and complex types description.


>
>        Ingo
>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbZA2PSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbZA2PSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbZA2PR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:17:57 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:8061 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZA2PR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:17:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DzBM1Ds4+E2QKvEJ1JNPko4P2oW3Z8VLOT1RwmmtATDrCJ909hzVEqKzS3HWhPdutp
         ibFudybVC2vPOieYeihOgK2Ro60pxIXI3EC6/5CTljfL7OJBQOqV6zSBAr3AZVYc6jR7
         TLfHyWDt5lmMu4wGlw7dgEH2Q4UhnN8vTJHy8=
MIME-Version: 1.0
In-Reply-To: <20090129150934.GF6512@elte.hu>
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere>
	 <20090127225048.GA4652@nowhere> <20090129140451.GM24391@elte.hu>
	 <c62985530901290629i168ac12cjc4b22140caceff58@mail.gmail.com>
	 <20090129143120.GS24391@elte.hu>
	 <c62985530901290640j10e63127s59ce22e860a508f8@mail.gmail.com>
	 <20090129150934.GF6512@elte.hu>
Date: Thu, 29 Jan 2009 16:17:54 +0100
Message-ID: <c62985530901290717j1d72d26vdfa77d02a8d6fef5@mail.gmail.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, srostedt@redhat.com,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>, utrace-devel@redhat.com,
       Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/29 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> 2009/1/29 Ingo Molnar <mingo@elte.hu>:
>> >>
>> >> Several people talked me about utrace and gave some examples about it in
>> >> this discussion. The Api is very convenient to fetch syscall numbers,
>> >> arguments and return values. And the hooks are done in the generic core
>> >> code, so it is arch independent.
>> >>
>> >> The only drawback I can see is that it is not yet merged upstream, in
>> >> need of in-kernel users. If it only depends on this condition, we could
>> >> be these users...
>> >>
>> >> What do you think?
>> >
>> > sure - how do the minimal bits/callbacks look like which enable syscall
>> > tracing?
>> >
>> >        Ingo
>>
>>
>> There is a very straightforward example provided by Ananth in there:
>> http://lkml.org/lkml/2009/1/28/59
>
> I mean, how does the infrastructure patch look like - what code does this
> add to the kernel - just to get the syscall tracing bits. Lets get some
> progress here - it's clear that tracing syscalls is good, we just need to
> do it and look at actual patches.
>
>        Ingo
>

The latest snapshot version I've found is here:
http://people.redhat.com/roland/utrace/2.6-current/utrace.patch
This is mostly independent core code and a good number of hooks inside ptrace.

But I don't know much about the overhead it potentially brings on ptrace.

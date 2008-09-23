Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYIWVC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYIWVC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYIWVCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:02:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48165 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYIWVCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:02:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=jelKqt6mZ44uJoTO6VVbDtiL+vfHJmx/UsZzjDDlV9vHKCJ4KkHG9wb04xZXduFG7
	kPGHFQFxfWt6qwLnCBQJA==
Message-ID: <33307c790809231402o24c93820tcfbf80d116c729c3@mail.gmail.com>
Date: Tue, 23 Sep 2008 14:02:08 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: Unified tracing buffer
Cc: "Masami Hiramatsu" <mhiramat@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
In-Reply-To: <alpine.LFD.1.10.0809232157580.2038@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <alpine.LFD.1.10.0809230847360.3265@nehalem.linux-foundation.org>
	 <48D921B3.2060809@redhat.com>
	 <alpine.LFD.1.10.0809231927060.2038@apollo.tec.linutronix.de>
	 <48D93CAF.8070000@redhat.com>
	 <alpine.LFD.1.10.0809232129280.2038@apollo.tec.linutronix.de>
	 <33307c790809231238m1e80fef4rce8a80722ff245f1@mail.gmail.com>
	 <alpine.LFD.1.10.0809232140090.2038@apollo.tec.linutronix.de>
	 <33307c790809231250y298ede7cqbee5a613ed6dbad5@mail.gmail.com>
	 <alpine.LFD.1.10.0809232157580.2038@apollo.tec.linutronix.de>
X-GMailtapped-By: 172.24.198.93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I think the tolerance is about 500 cycles. If that's not sufficient, I guess
>> we'll have to either live with some slight misordering (which people have
>> pointed out is kind of inevitable anyway) on these broken machines?
>> It was sufficient for what we were using it for, but maybe not for everyone.
>
> Well, I dont care about the trace reordering at all. I care about user
> space visible time going backwards issues observed via the
> gettimeofday vsyscall. 500 cycles should be fine, I doubt that we can
> migrate in less than that :)

Right, that's what we were interested in.

> I guess you try this only for machines where the TSC runs with
> constant frequency, right ?

We don't do DVFS on the 'broken' TSC machines, just halt.
But yes, it's selective

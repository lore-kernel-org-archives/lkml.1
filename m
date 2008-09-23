Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYIWTu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYIWTu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYIWTut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:50:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36311 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYIWTus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:50:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=KVMFWgzsQQdbJbNdI/q1T4QVbsAK+8N0XWlFqrbJoVKVpyrAj+gzCTHPmX8GR6oy0
	EMQLbvRhXS6Lc/fPWAU7Q==
Message-ID: <33307c790809231250y298ede7cqbee5a613ed6dbad5@mail.gmail.com>
Date: Tue, 23 Sep 2008 12:50:40 -0700
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
In-Reply-To: <alpine.LFD.1.10.0809232140090.2038@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <20080923150410.GA28341@Krystal> <48D90B84.4030905@redhat.com>
	 <alpine.LFD.1.10.0809230847360.3265@nehalem.linux-foundation.org>
	 <48D921B3.2060809@redhat.com>
	 <alpine.LFD.1.10.0809231927060.2038@apollo.tec.linutronix.de>
	 <48D93CAF.8070000@redhat.com>
	 <alpine.LFD.1.10.0809232129280.2038@apollo.tec.linutronix.de>
	 <33307c790809231238m1e80fef4rce8a80722ff245f1@mail.gmail.com>
	 <alpine.LFD.1.10.0809232140090.2038@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > Yup, explains your TSC observation. Nothing we can do about. Broken by
>> > system design :( Welcome in the wonderful world of Inhell/BIOS/ACPI !
>>
>> We have linux patches that sync the TSC on exit_idle. I'll see if I can get
>> Michael to send them out.
>
> Are you sure that they sync it precicely enough that there is no user
> space observable way of time going backwards between cores ?

I think the tolerance is about 500 cycles. If that's not sufficient, I guess
we'll have to either live with some slight misordering (which people have
pointed out is kind of inevitable anyway) on these broken machines?
It was sufficient for what we were using it for, but maybe not for everyone.

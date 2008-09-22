Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYIVXQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYIVXQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYIVXQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:16:49 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5679 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753543AbYIVXQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:16:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=kwyr31QJFn2KRC3pNs5q0KyE6nodJDm+1MU0brXRsPXnA+MiseviEoRr7wLpFRMbO
	YC+WxRcy9w8bJI82AAv1Q==
Message-ID: <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
Date: Mon, 22 Sep 2008 16:16:41 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: Unified tracing buffer
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
In-Reply-To: <48D81B5F.2030702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <48D7F5E8.3000705@redhat.com>
	 <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>
	 <48D81B5F.2030702@redhat.com>
X-GMailtapped-By: 172.24.198.101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> One thing that I think is still important is to have a unified timestamp
>> mechanism on everything, so we can co-ordinate different things back
>> together in userspace from different trace tools, so I intend to keep
>> that at a lower level, but I think you're right that the event id, etc can
>> move up into separate layers.
>
> I'm not so sure that the unified 'timestamp' must be required by all tracers.
> If you just need to merge and sort per-cpu data, you can use an atomic
> sequential number for it.
> IMHO, the unified 'timestamp' would better be an option, because some
> architectures can't support it. I think preparing timestamp-callback
> function will help us.

An atomic sequential number is:

(a) far less meaningful than a timestamp for the user
(b) more expensive to compute in many cases.

I think we came up with a way to approximate this, using a callback every
ms or so as the higher order bits, and a sequential counter in the lower
order for those broken platforms.

But perhaps it would be better if we started with a discussion of which
platforms can't do global timestamps, and why not? I know some of them
are fixable, but perhaps not all.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbYIVUNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbYIVUNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbYIVUNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:13:37 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37878 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYIVUNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:13:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=ltAJvb2+dQfjZRW921KLGWJA7rDiyS295V0We0LqhvnEI/GoAIKf8irVRR9uBG2T7
	FoH7Of8Ov5sh15aiAYjDA==
Message-ID: <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>
Date: Mon, 22 Sep 2008 13:13:28 -0700
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
In-Reply-To: <48D7F5E8.3000705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <48D7F5E8.3000705@redhat.com>
X-GMailtapped-By: 172.28.16.148
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree to integrate tracing buffer mechanism, but I don't think
> your proposal is the simplest one.
>
> To simplify, I think the layered buffering mechanism is desirable.
> - The lowest layer just provides named circular buffers(both per-cpu and
>  uni-buffer in system) and read/write scheme.
> - Next layer provides user/kernel interface including controls.
> - Top layer defines packet(and event) formatting utilities.
> - Additionally, it would better provide some library routines(timestamp,
>  event-id synchronize, and so on).
>
> Since this unified buffer is used from different kind of tracers/loggers,
> I don't think all of them(and future tracers) want to be tied down by
> "event-id"+"parameter" format.
> So, Sorry, I disagree about that the tracing buffer defines its *data format*,
> it's just overkill for me.

I think you're right that we can layer this, and we didn't make a particularly
good job of splitting those things out. I'll try to pull together
another revision
to reflect this and other suggested changes.

One thing that I think is still important is to have a unified timestamp
mechanism on everything, so we can co-ordinate different things back
together in userspace from different trace tools, so I intend to keep
that at a lower level, but I think you're right that the event id, etc can
move up into separate layers.

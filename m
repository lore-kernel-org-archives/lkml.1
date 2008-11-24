Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYKXUTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYKXUTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYKXUS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:18:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:26990 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYKXUS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:18:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=M4zwU9pT2K2sy//rEH/MMHunqC6EjJEKJ9E9WaxP4aO/KqpQauaQXmVpUxuEHiKnSW
         o7JEENhYGTEkKOl7AJFPpACz3ODl6ae+urcDvqvY+TXN4tCQhwetuBAW1/OglAZslD67
         2TotwDumPk06l11nAUkzRJ0R66omaC9yioGfY=
Date: Mon, 24 Nov 2008 22:18:49 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com
Subject: Re: [PATCH 1/2] mmiotrace: fix buffer overrun detection
Message-ID: <20081124221849.33c91bcf@daedalus.pq.iki.fi>
In-Reply-To: <20081123193413.GB2794@elte.hu>
References: <20081123154148.04e0851a@daedalus.pq.iki.fi>
	<alpine.DEB.1.10.0811231134150.27108@gandalf.stny.rr.com>
	<20081123212430.4f6700e9@daedalus.pq.iki.fi>
	<20081123193413.GB2794@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2008 20:34:13 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> Sure - applied them to tip/tracing/urgent:
> 
>   fb91ee6: tracing, doc: update mmiotrace documentation
>   7ee1768: x86, mmiotrace: fix buffer overrun detection
> 
> Does this make mmiotrace fully functional in .28 ?

Oh right, the busylooping bug when echoing into trace_marker,
I already forgot about that, since I couldn't reproduce it.
I guess there's nothing to do, until someone finds a way to
reproduce it.

I could speculate about buffer wrap-around issues or such, but
that requires some serious code reviewing. Btw. C-c'ing didn't
interrupt the shell while spinning. The spinning ended when I
switched the tracer or disabled it, IIRC.

(This is related to 2.6.28-rc6.)

On Sun, 23 Nov 2008, Pekka Paalanen wrote:

> There's also another issue, but I am not sure how to reproduce it.
> The symptom is, that
> echo whatever > /debug/tracing/trace_marker
> gets stuck in a loop, bash eats 100% CPU: 10% user, 90% system.
> I got that twice today, like this: after a fresh boot echoing 64, 200,
> 70 to trace_entries, switching between nop and mmiotrace tracers,
> echoing 0 or 1 to tracing_enabled, and running the testmmiotrace
> module. At some point the user marker got stuck.
> 
> But then I tried to do that a third time by repeating some usage
> patterns I thought might trigger it, but it didn't happen.


-- 
Pekka Paalanen
http://www.iki.fi/pq/

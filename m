Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYKERB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYKERB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYKERBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:01:21 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:51056 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYKERBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:01:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BrmQ2OWYJdYisRLdpWl1XovpqhREcdd/KNozcCOw+Plz/mxQ+YBjVhD9y40tZ3Q7mG
         ftQmud+TZpzjW3avGCUoeJgErS8u9Pq3jRtn2iLCo3sVyD8l1DV++Jn2WADog3VwuEy6
         ypoPIACwpf+OmiLWwz1QX3PVr0aKk17B1+m/s=
Message-ID: <c62985530811050901w2feeee37r65af91657cfbd9b6@mail.gmail.com>
Date: Wed, 5 Nov 2008 18:01:18 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: bug: ftrace & lockdep badness
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0811051143420.11900@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081105123714.GA23504@osiris.boeblingen.de.ibm.com>
	 <alpine.DEB.1.10.0811051054430.11900@gandalf.stny.rr.com>
	 <20081105163052.GA28884@elte.hu>
	 <alpine.DEB.1.10.0811051143420.11900@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/5 Steven Rostedt <rostedt@goodmis.org>:
> I do like the fact that lockdep checks it too. But there's times that we
> can not do that.
>
> Perhaps we can do something in between.
>
> Make a rb_spin_lock macro inside ring_buffer.c that can be either a
> spin_lock or a raw_spin_lock.  There are some tracers that must have this
> as a raw (function trace, irqsoff and preemptoff), but the rest should be
> fine. We can make it where the rb_spin_lock is a raw lock when any of
> those three tracers are configured, and make it into a normal lock when
> they are not.


But this way we won't be able to have lockdep checks when only one of
those "raw-need" tracers are
configured. Wouldn't it better to set it as a function pointer? It
would dynamically reference spin_lock or
raw_spin_lock functions depending on what tracer is currently
selected. I think that wouldn't hardly impact
the performances....

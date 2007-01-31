Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbXAaIsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbXAaIsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 03:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367AbXAaIsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 03:48:31 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:57387 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932337AbXAaIsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 03:48:30 -0500
Date: Wed, 31 Jan 2007 11:47:56 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Kaz Kylheku <kaz@zeugmasystems.com>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org,
       libc-hacker@sources.redhat.com, libc-alpha@sources.redhat.com
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Message-ID: <20070131084756.GA3110@2ka.mipt.ru>
References: <66910A579C9312469A7DF9ADB54A8B7D5C2B90@exchange.ZeugmaSystems.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <66910A579C9312469A7DF9ADB54A8B7D5C2B90@exchange.ZeugmaSystems.local>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Wed, 31 Jan 2007 11:47:57 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 01:16:22PM -0800, Kaz Kylheku (kaz@zeugmasystems.com) wrote:
> Evgeniy Polyakov wrote:
> > I described in details why and how M:N model better, and its drawbacks
> > include all issues mentioned by Ulrich Drepper, but nevertheless its
> > advantages are far too superiour than those which can be
> > provided by 1:1
> > model.
> 
> M:N threading is an unnecessary performance hack that's needed by people
> who are living in a C or C++ exile away from some language that has
> lexical closures, generators or first-class continuations. Not having
> these niceties, they resort to emulating them with threads. The proper
> thing to do is to rewrite the code to use state machines which can be
> driven by any available thread. Or else, write yourself a
> source-to-source transformer that will give C the lexical closure,
> generator, or continuation features that you need to express the
> solution that way.
> 
> There is no need to retain any vestiges of a user space threading
> implementation when you have the real thing.
> 
> Programs which appear to benefit from that model are badly optimized or
> badly designed. A smartly written program uses an available thread to do
> as much work as possible, until that thread happens to block or its time
> slice burns up.

Do not mix languages like Erlang, specialy designed for concurrent
programming, with M:N threading model - they are completely different,
but you do not want to see this. As you pointed, one thread can do as
much as it need until it is blocked, and what next? Allocate new real
thread? You may want to see how things like JVM work, I seriously doubt
spwning new thread each time task blocks is a way to go. Even having
epoll does not help in many cases. And you forgot the price of
rescheduling in kernelspace and userspace - even with signals it differs
two times, with more intellegent case it differs in 20 times!
Virtual machine can have thousands of threads, actually it cant, since
it will kill Linux in rescheduling.

-- 
	Evgeniy Polyakov

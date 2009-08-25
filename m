Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZHYKsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZHYKsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZHYKsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:48:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:49218 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbZHYKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:48:07 -0400
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090825103907.GB28287@elte.hu>
References: <20090824092455.GA25267@elte.hu>
	 <1251106058.7538.149.camel@twins> <4A937505.5000209@cn.fujitsu.com>
	 <1251181266.7538.1016.camel@twins> <4A9385AA.508@cn.fujitsu.com>
	 <1251182405.7538.1050.camel@twins> <20090825090558.GC14003@elte.hu>
	 <1251191546.7538.1118.camel@twins> <20090825102215.GC26801@elte.hu>
	 <1251196359.7538.1133.camel@twins>  <20090825103907.GB28287@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Aug 2009 12:47:15 +0200
Message-Id: <1251197235.7538.1142.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 12:39 +0200, Ingo Molnar wrote:

> > Do you really wish to burden every tracepoint user with the extra 
> > logic needed to deal with modules?
> 
> Not necessarily - i'm just outlining why i think that the 'dont 
> allow subsystems to utilize tracepoint callbacks' is a restriction 
> we should not live with voluntarily.

Well, unless someone has a bright idea that's what it comes down to. And
not having to care about modules when using tracepoint wins hands down
for me.

The issue seems rather simple:

Either we force everybody who uses a tracepoint to care about modules,
be this by having to do try_get_module() themselves or by having to
listen to some notifier and have their callback forcibly dropped on
unload -- both suck IMO, suck very hard indeed.

Or by having modules that use their own tracepoint be stuck, because
once you block unlock when a tracepoint has callbacks, and it installed
a callback on itself, its not going to go away.

And since I don't care about modules at all and really wish they'd never
been invented...

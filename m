Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZHYJNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZHYJNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZHYJNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:13:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:56094 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbZHYJNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:13:19 -0400
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090825090558.GC14003@elte.hu>
References: <4A9214E3.2070807@cn.fujitsu.com>
	 <1251093660.7538.119.camel@twins> <4A923197.4040708@cn.fujitsu.com>
	 <1251097012.7538.123.camel@twins> <20090824092455.GA25267@elte.hu>
	 <1251106058.7538.149.camel@twins> <4A937505.5000209@cn.fujitsu.com>
	 <1251181266.7538.1016.camel@twins> <4A9385AA.508@cn.fujitsu.com>
	 <1251182405.7538.1050.camel@twins>  <20090825090558.GC14003@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Aug 2009 11:12:26 +0200
Message-Id: <1251191546.7538.1118.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 11:05 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Ah, my bad, I was thikning tracepoint_probe_register() was the 
> > thing that registered the tracepoint itself, not the callback.
> > 
> > Ok, then what's the problem?, don't do modules that consume their 
> > own tracepoints, seems simple enough.
> 
> is this a reasonable restriction? I dont see any reason why the act 
> of defining and providing a tracepoint should be exclusive of the 
> ability to make use of it.

It doesn't make sense to me, you don't need your own tracepoints because
you generate the events yourself, you already have them.

Furthermore, I much prefer this over spreading module gunk all over
tracepoint users.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZHYOxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZHYOxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbZHYOxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:53:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:46364 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbZHYOxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:53:38 -0400
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1251197235.7538.1142.camel@twins>
References: <20090824092455.GA25267@elte.hu>
	 <1251106058.7538.149.camel@twins> <4A937505.5000209@cn.fujitsu.com>
	 <1251181266.7538.1016.camel@twins> <4A9385AA.508@cn.fujitsu.com>
	 <1251182405.7538.1050.camel@twins> <20090825090558.GC14003@elte.hu>
	 <1251191546.7538.1118.camel@twins> <20090825102215.GC26801@elte.hu>
	 <1251196359.7538.1133.camel@twins>  <20090825103907.GB28287@elte.hu>
	 <1251197235.7538.1142.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Aug 2009 16:52:43 +0200
Message-Id: <1251211963.7538.1164.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 12:47 +0200, Peter Zijlstra wrote:
> On Tue, 2009-08-25 at 12:39 +0200, Ingo Molnar wrote:
> 
> > > Do you really wish to burden every tracepoint user with the extra 
> > > logic needed to deal with modules?
> > 
> > Not necessarily - i'm just outlining why i think that the 'dont 
> > allow subsystems to utilize tracepoint callbacks' is a restriction 
> > we should not live with voluntarily.
> 
> Well, unless someone has a bright idea that's what it comes down to. 

OK, I still think modules probing their own tracepoints its stupid [*],
but what you could do is iterate the tracepoint's callback list and see
if it has a callback outside of the module code section and then fail
the unload.

[*] in the really utterly fundamentally wrong stupid class.

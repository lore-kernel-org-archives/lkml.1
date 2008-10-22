Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYJVRWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYJVRWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYJVRW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:22:29 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:36261 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYJVRW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:22:29 -0400
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 4/4] Implement semaphore latency tracer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20081022154851.GL23060@elte.hu>
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
	 <1223817124-27239-6-git-send-email-edwintorok@gmail.com>
	 <1223838786.8634.8.camel@lappy.programming.kicks-ass.net>
	 <48F259A7.2030800@gmail.com> <20081022152842.GI23060@elte.hu>
	 <48FF49BD.8000608@gmail.com>  <20081022154851.GL23060@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Oct 2008 19:22:17 +0200
Message-Id: <1224696137.20069.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 17:48 +0200, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
> 
> > On 2008-10-22 18:28, Ingo Molnar wrote:
> > > hm, but the most common synchronization primitive are mutexes - and 
> > > those are not covered by your patchset.
> > >   
> > 
> > Indeed. I've seen a patch from Jason Baron to introduce tracepoints 
> > for mutexes, but the conclusion was that the tracepoints should be in 
> > lockstat instead.
> > 
> > And if lockstat is enabled Peter Zijlstra's 'contend with points' 
> > patch seems to do exactly what I want to.
> > 
> > However I think it would be useful to have (a tracepoints based?) 
> > latency tracker, which can be enabled/disabled at runtime, and which 
> > doesn't add any data to the mutex/semaphore structures. My patchset 
> > was a first attempt towards that, but it seems that such use of 
> > tracepoints is not welcome at this time?
> > 
> > Please tell me if I should continue working on this, or if I my 
> > patches are designed totally on the wrong way.
> 
> i think if you hook into Peter's lockstat APIs that should give us a 
> pretty good tracer, with no ugliness introduced. That would be rather 
> interesting. Peter, do you concur?

Yes, I've already suggested this. Use the exact same hooks that
lockdep/lockstat use.


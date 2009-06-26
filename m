Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbZFZTMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbZFZTMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbZFZTM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:12:27 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:32926 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbZFZTM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:12:26 -0400
X-SourceIP: 213.93.53.227
Subject: Re: performance counter 20% error finding retired instruction count
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
	 <20090624151010.GA12799@elte.hu>
	 <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 21:12:34 +0200
Message-Id: <1246043554.31755.207.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 14:22 -0400, Vince Weaver wrote:
> On Wed, 24 Jun 2009, Ingo Molnar wrote:
> > * Vince Weaver <vince@deater.net> wrote:
> >
> > Those ~2100 instructions are executed by your app: as the ELF
> > dynamic loader starts up your test-app.
> >
> > If you have some tool that reports less than that then that tool is
> > not being truthful about the true overhead of your application.
> 
> Wait a second... my application is a statically linked binary.  There is 
> no ELF dynamic loader involved at all.
> 
> On further investigation, all of the overhead comes _entirely_ from the 
> perf utility.  This is overhead and instructions that would not occur when 
> not using the perf utility.
> 
> From the best I can tell digging through the perf sources, the performance 
> counters are set up and started in userspace, but instead of doing an 
> immediate clone/exec, thousands of instructions worth of other stuff is 
> done by perf in between.
> 
> Ther "perfmon" util, plus linux-user simulators like qemu and valgrind do 
> things properly.  perf can't it seems, and it seems to be a limitation of 
> the new performance counter infrastructure.

perf can do it just fine, all you need is a will to touch ptrace().
Nothing in the perf counter design is limiting this to work.

I just can't really be bothered by this tiny and mostly constant offset,
esp if the cost is risking braindamage from touching ptrace(), but if
you think otherwise (and make the ptrace bit optional) I'm more than
willing to merge the patch.

> PS.  Why is the perf code littered with many many  __MINGW32__ defined?
>       Should this be in the kernel tree?  It makes the code really hard
>       to follow.  Are there plans to port perf to windows?

Comes straight from the git sources.. and littered might be a bit much,
I count only 11.

# git grep MING tools/perf | wc -l
11

But yeah, that might want cleaning up.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbZFZSLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbZFZSLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZFZSLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:11:47 -0400
Received: from smtpauth00.csee.onr.siteprotect.com ([64.26.60.144]:57167 "EHLO
	smtpauth00.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132AbZFZSLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:11:47 -0400
Date: Fri, 26 Jun 2009 14:22:40 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: performance counter 20% error finding retired instruction count
In-Reply-To: <20090624151010.GA12799@elte.hu>
Message-ID: <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
 <20090624151010.GA12799@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Ingo Molnar wrote:
> * Vince Weaver <vince@deater.net> wrote:
>
> Those ~2100 instructions are executed by your app: as the ELF
> dynamic loader starts up your test-app.
>
> If you have some tool that reports less than that then that tool is
> not being truthful about the true overhead of your application.

Wait a second... my application is a statically linked binary.  There is 
no ELF dynamic loader involved at all.

On further investigation, all of the overhead comes _entirely_ from the 
perf utility.  This is overhead and instructions that would not occur when 
not using the perf utility.

>From the best I can tell digging through the perf sources, the performance 
counters are set up and started in userspace, but instead of doing an 
immediate clone/exec, thousands of instructions worth of other stuff is 
done by perf in between.

Ther "perfmon" util, plus linux-user simulators like qemu and valgrind do 
things properly.  perf can't it seems, and it seems to be a limitation of 
the new performance counter infrastructure.


Vince

PS.  Why is the perf code littered with many many  __MINGW32__ defined?
      Should this be in the kernel tree?  It makes the code really hard
      to follow.  Are there plans to port perf to windows?



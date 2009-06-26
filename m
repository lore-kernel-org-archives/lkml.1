Return-Path: <linux-kernel-owner+w=401wt.eu-S1761293AbZFZTMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293AbZFZTMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbZFZTMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:12:38 -0400
Received: from smtpauth01.csee.onr.siteprotect.com ([64.26.60.145]:48018 "EHLO
	smtpauth01.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760300AbZFZTMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:12:37 -0400
Date: Fri, 26 Jun 2009 15:23:33 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: performance counter 20% error finding retired instruction count
In-Reply-To: <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
Message-ID: <Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
 <20090624151010.GA12799@elte.hu> <Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009, Vince Weaver wrote:

> From the best I can tell digging through the perf sources, the performance 
> counters are set up and started in userspace, but instead of doing an 
> immediate clone/exec, thousands of instructions worth of other stuff is done 
> by perf in between.

and for the curious, wondering how a simple
   prctl(COUNTERS_ENABLE);
   fork()
   execvp()

can cause 6000+ instructions of non-deterministic execution, it turns out 
that perf is dynamically linked.  So it has to spend 5000+ cycles in 
ld-linux.so resolving the excecvp() symbol before it can actually execvp.

So when trying to get accurate profiles of simple statically linked 
programs, you still have to put up with the dynamic loader overhead 
because of the way perf is designed.  nice.

Vince

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbZF0Gsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbZF0Gsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 02:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZF0Gsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 02:48:35 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60900 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZF0Gsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 02:48:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19013.49344.860564.948905@cargo.ozlabs.ibm.com>
Date: Sat, 27 Jun 2009 16:48:32 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vince Weaver <vince@deater.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: performance counter ~0.4% error finding retired instruction
	count
In-Reply-To: <20090627060432.GB16200@elte.hu>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
	<20090624151010.GA12799@elte.hu>
	<Pine.LNX.4.64.0906261417560.23467@pianoman.cluster.toy>
	<Pine.LNX.4.64.0906261520030.23653@pianoman.cluster.toy>
	<20090627060432.GB16200@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> I measured 2000, but generally a few thousand cycles per invocation 
> sounds about right.

We could actually do a bit better than we do, fairly easily.  We could
attach the counters to the child after the fork instead of the parent
before the fork, using a couple of pipes for synchronization.  And
there's probably a way to get the dynamic linker to resolve the execvp
call early in the child so we avoid that overhead.  I think we should
be able to get the overhead down to tens of userspace instructions
without doing anything unnatural.

Paul.

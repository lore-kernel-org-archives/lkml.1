Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbYLPOnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbYLPOnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbYLPOnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:43:43 -0500
Received: from viefep16-int.chello.at ([62.179.121.36]:41615 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754525AbYLPOnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:43:42 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] Performance Counters for Linux, v4
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
In-Reply-To: <18758.53072.197695.277198@cargo.ozlabs.ibm.com>
References: <20081214212829.GA9435@elte.hu>
	 <Pine.LNX.4.64.0812151243130.2773@pianoman.cluster.toy>
	 <18758.53072.197695.277198@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 15:42:59 +0100
Message-Id: <1229438579.7025.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 08:42 +1100, Paul Mackerras wrote:
> the execvp would be hard to get rid of without using ptrace() - and
> the use of ptrace was one of the things that Ingo et al. objected to
> in perfmon3.

I don't think using ptrace in this case is a big issue - aside from the
fact that ptrace is crap in that you'd not be able to timec from a
debugger context :-(

The biggest objection to using ptrace was that ptrace was needed
_during_ the execution of the monitored load, thereby distorting the
load.

This case is different in that it would be used to start off the load.

Still it would be good if we could find another (elegant) way to fix
this.

Also, I'm pretty sure the regular 'time' suffers the very same issue and
counts the exec syscall as well - I saw that when I tinkered with the
execve argument code.

Furthermore, I think output of tools such as time and now timec are most
relevant when compared between runs - that is, the change in values
between runs, not the absolute values as such. At least, that's what I
usually do:

 time ./foo

tinker with foo.c

 time ./foo

if time2 < time1 :-)
else :-(



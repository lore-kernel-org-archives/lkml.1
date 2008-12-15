Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbYLOVm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbYLOVm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbYLOVmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:42:50 -0500
Received: from ozlabs.org ([203.10.76.45]:32845 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbYLOVmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:42:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18758.53072.197695.277198@cargo.ozlabs.ibm.com>
Date: Tue, 16 Dec 2008 08:42:40 +1100
From: Paul Mackerras <paulus@samba.org>
To: Vince Weaver <vince@deater.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
In-Reply-To: <Pine.LNX.4.64.0812151243130.2773@pianoman.cluster.toy>
References: <20081214212829.GA9435@elte.hu>
	<Pine.LNX.4.64.0812151243130.2773@pianoman.cluster.toy>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince Weaver writes:

> I see a large (2300 instruction) fixed overhead when measuring
> retired instruction count using the "timec" command
> compared to the "pfmon" tool that comes with perfmon3
> (the pfmon tool has essentially no overhead when
> doing aggragate counts).

Looks like timec will be counting the fork() and execvp() system calls
that are used to run your executable, as well as the executable
itself.  The fork() overhead could be removed fairly easily I think,
the execvp would be hard to get rid of without using ptrace() - and
the use of ptrace was one of the things that Ingo et al. objected to
in perfmon3.

Paul.

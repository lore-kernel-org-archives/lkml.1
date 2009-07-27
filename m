Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZG0QyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZG0QyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZG0QyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:54:18 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:6333 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZG0QyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:54:18 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counters issue with self-sampling threads
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 18:56:41 +0200
Message-Id: <1248713801.6987.1684.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 18:51 +0200, stephane eranian wrote:
> Hi,
> 
> I believe there is a problem with the current perf_counters (PCL)
> code for self-sampling threads. The problem is related to sample
> notifications via signal.
> 
> PCL (just like perfmon) is using SIGIO, an asynchronous signal,
> to notify user applications of the availability of data in the event
> buffer.
> 
> POSIX does not mandate that asynchronous signals be delivered
> to the thread in which they originated. Any thread in the process
> may process the signal, assuming it does not have the signal
> blocked.

Bugger, you're right. /me kicks POSIX again for creating these crazy ass
semantics.

I'll look at fixing this.

Thanks!


Return-Path: <linux-kernel-owner+w=401wt.eu-S933349AbZINSct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349AbZINSct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933342AbZINSco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:32:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338AbZINScm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:32:42 -0400
Subject: Re: Warning from ring buffer code (Was: Re: linux-next: tip tree 
 build warning)
From: Steven Rostedt <srostedt@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christopher Li <sparse@chrisli.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-sparse@vger.kernel.org, Josh Triplett <josh@freedesktop.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1252952621.31964.0.camel@twins>
References: <20090804161640.70817ee6.sfr@canb.auug.org.au>
	 <1249403089.4634.139.camel@localhost.localdomain>
	 <20090912165300.9d257283.sfr@canb.auug.org.au>
	 <20090912073906.GA3972@elte.hu> <1252753957.12217.10.camel@ht.satnam>
	 <1252941416.2964.143.camel@localhost.localdomain>
	 <70318cbf0909141009v46581785m4c70edf31fcb79fa@mail.gmail.com>
	 <1252952238.2964.154.camel@localhost.localdomain>
	 <1252952621.31964.0.camel@twins>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 14 Sep 2009 14:31:16 -0400
Message-Id: <1252953076.2964.156.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 20:23 +0200, Peter Zijlstra wrote:
> On Mon, 2009-09-14 at 14:17 -0400, Steven Rostedt wrote:
> > Frederic, how big can one of those events get. The ring buffer (and
> > TRACE_EVENT) allow up to almost a page size, which is very hefty for the
> > stack. This code needs to either be rewritten or we need to set a limit
> > to the size of a profile entry.
> 
> Yeah, that needs to get a re-write.. I've complained about this when it
> went in.

One answer is to create a per cpu buffer that is big enough to hold the
data needed. Then you can disable interrupts an use it without worry.

If you need to also handle NMIs, then create a per_cpu NMI buffer too,
and use that if "in_nmi()" is true.

-- Steve



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZBDAev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZBDAev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZBDAem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:34:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:38387 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZBDAem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:34:42 -0500
Subject: Re: [PATCH v2] ftrace: On PowerPC we don't need frame pointers for
 CALLER_ADDRs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: avorontsov@ru.mvista.com
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090203185933.GA9878@oksana.dev.rtsoft.ru>
References: <20090131190650.GA4284@oksana.dev.rtsoft.ru>
	 <1233534919.18767.69.camel@pasglop>
	 <1233583455.16878.3.camel@localhost.localdomain>
	 <20090203145649.GA19955@oksana.dev.rtsoft.ru>
	 <20090203160645.GA9020@elte.hu> <20090203161955.GA776@oksana.dev.rtsoft.ru>
	 <1233678738.16878.5.camel@localhost.localdomain>
	 <20090203185933.GA9878@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 11:34:03 +1100
Message-Id: <1233707643.16867.115.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 21:59 +0300, Anton Vorontsov wrote:
> On Tue, Feb 03, 2009 at 11:32:18AM -0500, Steven Rostedt wrote:
> > 
> > On Tue, 2009-02-03 at 19:19 +0300, Anton Vorontsov wrote:
> > > On Tue, Feb 03, 2009 at 05:06:45PM +0100, Ingo Molnar wrote:
> > 
> > > [1] Btw, why exactly do we need the -fno-omit-frame-pointer for
> > > "FUNCTION_TRCER" tracer? Why just -pg isn't sufficient?..
> > > 
> > 
> > The problem is this that is in the toplevel Makefile:
> > 
> > 
> > ifdef CONFIG_FRAME_POINTER
> > KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
> > else
> > KBUILD_CFLAGS	+= -fomit-frame-pointer
> > endif
> > 

And don't forget the gcc bug that miscompiles function epilogues on ppc
with -fno-omit-frame-pointer (iirc), which we need to work around using
-mno-sched-epilog.

Currently, we set that only if CONFIG_FUNCTION_TRACER is set, ie, we
assume that we only set -fno-omit-frame-pointer when
CONFIG_FUNCTION_TRACER is set.

Ben.



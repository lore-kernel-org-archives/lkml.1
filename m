Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab0BRNZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 08:25:24 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:36393 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0BRNZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 08:25:22 -0500
Date: Thu, 18 Feb 2010 14:25:21 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
Message-ID: <20100218132521.GB2406@osiris.boeblingen.de.ibm.com>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com>
 <1266491616-6270-3-git-send-regression-fweisbec@gmail.com>
 <8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com>
 <20100218120944.GA2406@osiris.boeblingen.de.ibm.com>
 <8bd0f97a1002180412x6cc4f280u5444f013c6e3b670@mail.gmail.com>
 <20100218123453.GA5136@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100218123453.GA5136@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 01:34:57PM +0100, Frederic Weisbecker wrote:
> On Thu, Feb 18, 2010 at 07:12:08AM -0500, Mike Frysinger wrote:
> > On Thu, Feb 18, 2010 at 07:09, Heiko Carstens wrote:
> > > On Thu, Feb 18, 2010 at 06:18:20AM -0500, Mike Frysinger wrote:
> > >> On Thu, Feb 18, 2010 at 06:13, Frederic Weisbecker wrote:
> > >> > --- a/arch/Kconfig
> > >> > +++ b/arch/Kconfig
> > >> > @@ -121,6 +121,9 @@ config HAVE_DMA_ATTRS
> > >> >  config USE_GENERIC_SMP_HELPERS
> > >> >        bool
> > >> >
> > >> > +config HAVE_REGS_AND_STACK_ACCESS_API
> > >> > +       bool
> > >> > +
> > >>
> > >> could you add an appropriate help/comment so arch peeps know what
> > >> needs to be implemented before they can select this
> > >
> > > That's why I added the commit ID for the regs and stack access api
> > > to the changelog. imho that should be sufficient.
> > > Besides that the next commit would implement it for s390 as a
> > > blueprint for others. That is... for those that missed the initial
> > > x86 implementation.
> > 
> > people shouldnt have to dive into the changelog to try and divine
> > documentation.  it's hardly standard, so people fall on it in a
> > pima-last-resort kind of way.  being explicit in the file up front by
> > writing real documentation says other people a lot more time.
> > -mike
> 
> 
> Yeah, would be nice to have a comment above the config definition
> to explain what it implies.
> 
> Heiko, mind sending a delta patch for that?

Subject: [PATCH] tracing/kprobes: add short documentation for HAVE_REGS_AND_STACK_ACCESS_API

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -123,6 +123,10 @@ config USE_GENERIC_SMP_HELPERS
 
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
+	help
+	  This symbol should be selected by an architecure if it supports
+	  the API needed to access registers and stack entries from pt_regs.
+	  For example the kprobes-based event tracer needs this API.
 
 config HAVE_CLK
 	bool

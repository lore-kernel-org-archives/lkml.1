Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbZJALCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbZJALCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 07:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbZJALCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 07:02:18 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:53837 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbZJALCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 07:02:17 -0400
Date: Thu, 1 Oct 2009 13:02:19 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] move #define pr_fmt KBUILD_MODNAME and KMSG_COMPONENT to
 Makefiles?
Message-ID: <20091001130219.7f0db35d@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1254322378.2960.86.camel@Joe-Laptop.home>
References: <1254248104.28232.447.camel@Joe-Laptop.home>
	<20090930065533.GB13850@merkur.ravnborg.org>
	<1254297299.2960.55.camel@Joe-Laptop.home>
	<20090930112023.4fbb3da0@mschwide.boeblingen.de.ibm.com>
	<1254322378.2960.86.camel@Joe-Laptop.home>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 07:52:58 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2009-09-30 at 11:20 +0200, Martin Schwidefsky wrote:
> > On Wed, 30 Sep 2009 00:54:59 -0700
> > Joe Perches <joe@perches.com> wrote:
> > > If something like were added to a module Makefile:
> > > 	ccflags-y += -D "pr_fmt(fmt)=KBUILD_MODNAME \": \" fmt"
> > 
> > Where is the difference between the definition of the macro in the 
> > source file? It's still one additional line, no?
> 
> Look at net/netfilter/ipvs for instance.
> 
> It would have been possible to add:
> 
> 	ccflags-y += -D "KMSG_COMPONENT=IPVS"
> 	ccflags-y += -D "pr_fmt(fmt)=KMSG_COMPONENT \": \" fmt"
> 
> to net/netfilter/ipvs/Makefile instead of adding it
> to 23 files.

That can make sense if you have lots of files that use the same
KMSG_COMPONENT. 

> Same sort of thing for drivers/s390/char/Makefile,
> though it's less beneficial there.
> 
> Multiple
> 	CFLAGS_foo.o += -D "KMSG_COMPONENT=foo"
> and a single
> 	ccflags-y += -D "pr_fmt(fmt)=KMSG_COMPONENT \": \" fmt"
> 
> > And if you are dreaming of converting all source files
> > to the pr_fmt mechanism, this is a big effort ..
> 
> I think it could be a useful mechanism to define pr_fmt
> for individual module Makefiles and there's no rush...

If you need multiple
	CFLAGS_foo.o += -D "KMSG_COMPONENT=foo"
lines the benefit of the Makfile method is limited. In general I find
the code to be less clear if I have to search for the message prefix in
the Makefile instead of the start of the C file. Personal preference I
guess.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


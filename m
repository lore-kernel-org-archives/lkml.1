Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZI3Ow4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZI3Ow4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZI3Ow4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:52:56 -0400
Received: from mail.perches.com ([173.55.12.10]:1447 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbZI3Owz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:52:55 -0400
Subject: Re: [RFC] move #define pr_fmt KBUILD_MODNAME and KMSG_COMPONENT to
 Makefiles?
From: Joe Perches <joe@perches.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090930112023.4fbb3da0@mschwide.boeblingen.de.ibm.com>
References: <1254248104.28232.447.camel@Joe-Laptop.home>
	 <20090930065533.GB13850@merkur.ravnborg.org>
	 <1254297299.2960.55.camel@Joe-Laptop.home>
	 <20090930112023.4fbb3da0@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 07:52:58 -0700
Message-Id: <1254322378.2960.86.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 11:20 +0200, Martin Schwidefsky wrote:
> On Wed, 30 Sep 2009 00:54:59 -0700
> Joe Perches <joe@perches.com> wrote:
> > If something like were added to a module Makefile:
> > 	ccflags-y += -D "pr_fmt(fmt)=KBUILD_MODNAME \": \" fmt"
> 
> Where is the difference between the definition of the macro in the 
> source file? It's still one additional line, no?

Look at net/netfilter/ipvs for instance.

It would have been possible to add:

	ccflags-y += -D "KMSG_COMPONENT=IPVS"
	ccflags-y += -D "pr_fmt(fmt)=KMSG_COMPONENT \": \" fmt"

to net/netfilter/ipvs/Makefile instead of adding it
to 23 files.

Same sort of thing for drivers/s390/char/Makefile,
though it's less beneficial there.

Multiple
	CFLAGS_foo.o += -D "KMSG_COMPONENT=foo"
and a single
	ccflags-y += -D "pr_fmt(fmt)=KMSG_COMPONENT \": \" fmt"

> And if you are dreaming of converting all source files
> to the pr_fmt mechanism, this is a big effort ..

I think it could be a useful mechanism to define pr_fmt
for individual module Makefiles and there's no rush...

cheers, Joe


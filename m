Return-Path: <linux-kernel-owner+w=401wt.eu-S936230AbXGMUrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936230AbXGMUrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 16:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761032AbXGMUrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 16:47:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53972 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761267AbXGMUrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 16:47:10 -0400
Date: Fri, 13 Jul 2007 22:48:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maps2-move-the-page-walker-code-to-lib.patch
Message-ID: <20070713204817.GA3529@uranus.ravnborg.org>
References: <1183873796.6005.269.camel@localhost.localdomain> <20070709202217.GS11115@waste.org> <1184033195.6005.439.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184033195.6005.439.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 12:06:35PM +1000, Rusty Russell wrote:
> On Mon, 2007-07-09 at 15:22 -0500, Matt Mackall wrote:
> > On Sun, Jul 08, 2007 at 03:49:56PM +1000, Rusty Russell wrote:
> > > Matt wrote:
> > > > This lets it get shared outside of proc/ and linked in only when needed.
> > > 
> > > Erk, this really belongs in the mm dir.  You can use "lib-y +=
> > > pagewalk.o" there, and it seems to work as well as doing it in lib.
> > 
> > Are you sure? I tested that a few months ago and it didn't work for
> > me. I seem to recall it wanted a chunk of makefile surgery.
> 
> Well, I tested here and it worked unless I screwed something (producing
> lib.a in mm/ and linking it in).  And when I turned off all the CONFIG
> options which required it, the symbols disappeared from the vmlinux...

I think you had some additional change somewhere...
kbuild will only look for lib.a files (produced from all files
listed with lib-y _except_ files listed with obj-y too).

kbuild by default know about lib/ but almost all archs
add the directory: arch/$(ARCH)/lib but no-one
add mm/.
See assignment to libs-y.

Add see the bad documentation in Documentation/kbuild/makefiles.txt

	Sam

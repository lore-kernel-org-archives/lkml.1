Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbXERXRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbXERXRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 19:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbXERXRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 19:17:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59002 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbXERXRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 19:17:38 -0400
Date: Fri, 18 May 2007 16:19:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: building i386 requires s390: "driver/crypto/Kconfig" sourcing
 s390 arch
Message-Id: <20070518161920.ae0ed062.randy.dunlap@oracle.com>
In-Reply-To: <464E1E9A.8060605@tlinx.org>
References: <464DFF5F.5010905@tlinx.org>
	<20070518141735.aae3921a.randy.dunlap@oracle.com>
	<464E1E9A.8060605@tlinx.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 14:46:02 -0700 Linda Walsh wrote:

> Randy Dunlap wrote:
> > On Fri, 18 May 2007 12:32:47 -0700 Linda Walsh wrote:
> >
> >   
> >> Seems there is an include of s390 based config in file
> >> drivers/crypto/Kconfig: source "arch/s390/crypto/Kconfig"
> >>
> >> The line doesn't seem to be need for an i386 build (haven't
> >> tried x86_64 though).
> >>
> >> I take it that this was a braino?
> >>     
> >
> > Does it cause a problem?  If yes, what problem?
> >   
> ----
>     Yes.  My source tree has unrelated architectures removed,
> as a result when building i386 or x86_64, the config tools try to
> include files from the s390 architecture.  It isn't there. 
> I'm building x86, why should I be including files from other
> architectures.  It is hierarchically unclean.

Yes, it is.  What removes all arch-except-i386-and-x86_64 from your
kernel tree?  Can't it also do
$ sed @source "arch/s390/crypto/Kconfig"@#source "arch/s390/crypto/Kconfig"@
at the same time?

Who supports a pared-down kernel tree like this?


>     Perhaps the s390 device needs to be moved under the crypto with
> the other crypto devices?   

Sorry, I didn't quite understand that part.

> If the standard that other architectures are
> using is to put their devices in the crypto directory, then one might
> expect all crypto devices to be there.  Why should s390 stick out and
> put its crypto device someplace under the s390 tree, forcing parts of the
> s390 tree to be included when building other architectures? 

drivers/crypto/ currently contains drivers for x86_32 and s390
(the latter by indirection, which is what is causing you this
grief/problem/whatever), but it certainly looks like it could
be a home for crypto drivers on any arch.


> > It looks like someone thought that all Hardware crypto devices
> > should be listed under the same menu heading.  Makes some sense.
> >   
> I thought the idea was the menu reflected the options available in
> the specific parts/branches -- i.e. if you have the menu option in
> the crypto tree, then the source code should be there as well.

I'm not aware of that.  E.g., i386 and x86_64 share a lot of code
via "#include ../foo/bar" (and it's bad/ugly).

> I'm not sure how flexible the include system is, but can't it be
> "not included" unless compiling for ARCH_s390?

That would be the best solution IMO, if it only worked.  :(

E.g.:

if S390
source "arch/s390/crypto/Kconfig"
endif

in drivers/crypto/Kconfig.  Alas, it doesn't work.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

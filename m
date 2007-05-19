Return-Path: <linux-kernel-owner+w=401wt.eu-S1762217AbXESFiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762217AbXESFiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbXESFh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:37:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:40867 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbXESFh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:37:58 -0400
Date: Sat, 19 May 2007 07:38:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linda Walsh <lkml@tlinx.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: building i386 requires s390: "driver/crypto/Kconfig" sourcing s390 arch
Message-ID: <20070519053855.GA20500@uranus.ravnborg.org>
References: <464DFF5F.5010905@tlinx.org> <20070518141735.aae3921a.randy.dunlap@oracle.com> <464E1E9A.8060605@tlinx.org> <20070518161920.ae0ed062.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518161920.ae0ed062.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 04:19:20PM -0700, Randy Dunlap wrote:
> On Fri, 18 May 2007 14:46:02 -0700 Linda Walsh wrote:
> 
> > Randy Dunlap wrote:
> > > On Fri, 18 May 2007 12:32:47 -0700 Linda Walsh wrote:
> > >
> > >   
> > >> Seems there is an include of s390 based config in file
> > >> drivers/crypto/Kconfig: source "arch/s390/crypto/Kconfig"
> > >>
> > >> The line doesn't seem to be need for an i386 build (haven't
> > >> tried x86_64 though).
> > >>
> > >> I take it that this was a braino?
> > >>     
> > >
> > > Does it cause a problem?  If yes, what problem?
> > >   
> > ----
> >     Yes.  My source tree has unrelated architectures removed,
> > as a result when building i386 or x86_64, the config tools try to
> > include files from the s390 architecture.  It isn't there. 
> > I'm building x86, why should I be including files from other
> > architectures.  It is hierarchically unclean.
> 
> Yes, it is.  What removes all arch-except-i386-and-x86_64 from your
> kernel tree?  Can't it also do
> $ sed @source "arch/s390/crypto/Kconfig"@#source "arch/s390/crypto/Kconfig"@
> at the same time?
> 
> Who supports a pared-down kernel tree like this?

On op of this I have previously discussed with Roman Zippel
the possibility to have _one_ include hirachy for Kconfig files.
So that kconfig would fetch all Kconfig files for all archs.

	Sam

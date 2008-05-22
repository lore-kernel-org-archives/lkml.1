Return-Path: <linux-kernel-owner+w=401wt.eu-S1764752AbYEVXpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764752AbYEVXpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759035AbYEVXox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:44:53 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51128 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272AbYEVXow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:44:52 -0400
Subject: Re: build issue #503 for v2.6.26-rc2-433-gf26a398 :  undefined
	reference to `request_firmware'
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20080517141749.GD3284@cs181133002.pp.htv.fi>
References: <200805161906.19321.toralf.foerster@gmx.de>
	 <1211018673.3603.7.camel@localhost.localdomain>
	 <20080517141749.GD3284@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=utf-8
Date: Thu, 22 May 2008 11:52:24 +0100
Message-Id: <1211453544.3956.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-17 at 17:17 +0300, Adrian Bunk wrote:
> On Sat, May 17, 2008 at 11:04:31AM +0100, James Bottomley wrote:
> > On Fri, 2008-05-16 at 19:06 +0200, Toralf Förster wrote:
> > > Hello,
> > > 
> > > the build (.config attached) failed, make ends with :
> > > ...
> > >   UPD     include/linux/compile.h
> > >   CC      init/version.o
> > >   LD      init/built-in.o
> > >   LD      vmlinux
> > > drivers/built-in.o: In function `sas_request_addr':
> > > (.text+0x33bab): undefined reference to `request_firmware'
> > > drivers/built-in.o: In function `sas_request_addr':
> > > (.text+0x33c3f): undefined reference to `release_firmware'
> > > make: *** [vmlinux] Error 1
> > 
> > There's a slight fault in the stub logic.  It fails for FW_LOADER=m and
> > the user =y.
> > 
> > This should fix it.
> 
> An interesting question is whether we actually want to have the stub at 
> all - the compile errors catched cases where someone forgot to select 
> FW_LOADER at compile time instead of turning them into possible runtime 
> problems as will happen after your patch.

Well, the original intent of the stubs was to have the loader nop if it
wasn't available.  There was simply one case forgotten (the fact that a
modular loader isn't usable from built in components).

> Are there any serious use cases where SCSI_SAS_LIBSAS is used in very 
> space limited environments and without any other drivers that select 
> FW_LOADER in the kernel?

Probably in the future, certainly on embedded OSs used for storage
devices.  Given the convergence of SAS/SATA chips, it's possible for
other handhelds, but I'm not convinced of that.

James



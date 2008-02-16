Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbYBPFZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbYBPFZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 00:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYBPFZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 00:25:04 -0500
Received: from lixom.net ([66.141.50.11]:56870 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbYBPFZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 00:25:03 -0500
Date: Fri, 15 Feb 2008 23:27:38 -0600
From: Olof Johansson <olof@lixom.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jonas Bonn <jonas@southpole.se>, linux-kernel@vger.kernel.org
Subject: Re: pci_device_id definition cleanups
Message-ID: <20080216052737.GA18277@lixom.net>
References: <1203117700.16761.9.camel@satguru> <20080216022336.GA7740@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216022336.GA7740@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 03:23:36AM +0100, Sam Ravnborg wrote:
> On Sat, Feb 16, 2008 at 12:21:40AM +0100, Jonas Bonn wrote:
> > I've done some work on cleaning up the definitions of pci_device_id to
> > make them "static const" (where possible) and to make sure they go into
> > __devinitconst.  There are about 350 changes of the type shown in the
> > diff at the end of this mail.
> > 
> > ???All these changes are in my public GIT tree at:
> > 
> > git://www.southpole.se/~jonas/git/linux.git
> > 
> > (Based on 2.6.25-rc2)
> > 
> > In addition to these pci_device_id changes, there are a few changesets
> > that move "const" data from __devinitdata to __devinitconst.
> > 
> > The tree above builds with both allmodconfig and allyesconfig.
> 
> Hi Jonas.
> 
> Can I ask you to try the same with ARCH=powerpc
> (or alpha or ia64).
> Becasue it is for these architectures we see issues with
> defining data const.

I pulled his tree and tried building on powerpc w/ gcc 4.3, it passed.

I'm not too excited about the extremely long open-coded variable
definitions everywhere now though. Wouldn't it be better to just do a
macro for it?

Something like:

#define PCI_DEVICE_TABLE(_var) static const struct pci_device_id _var[] __devinitconst

And then just:

PCI_DEVICE_TABLE(mydevice_tbl) = {
	...
};


-Olof

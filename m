Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbXJ3MmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbXJ3MmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 08:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXJ3MmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 08:42:07 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:47396 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbXJ3MmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 08:42:05 -0400
Date: Tue, 30 Oct 2007 12:41:55 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org,
       Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
Subject: Re: [IDE] Fix build bug
Message-ID: <20071030124155.GA7582@linux-mips.org>
References: <20071025135334.GA23272@linux-mips.org> <200710252341.38902.bzolnier@gmail.com> <200710301134.30087.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710301134.30087.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 11:34:29AM +0000, Denys Vlasenko wrote:

> On Thursday 25 October 2007 22:41, Bartlomiej Zolnierkiewicz wrote:
> > > -static const struct ide_port_info generic_chipsets[] __devinitdata = {
> > > +static struct ide_port_info generic_chipsets[] __devinitdata = {
> > >  	/*  0 */ DECLARE_GENERIC_PCI_DEV("Unknown",	0),
> > >  
> > >  	{	/* 1 */
> > 
> > I would prefer to not remove const from generic_chipsets[] so:
> > 
> > [PATCH] drivers/ide/pci/generic: fix build for CONFIG_HOTPLUG=n
> > 
> > It turns out that const and __{dev}initdata cannot be mixed currently
> > and that generic IDE PCI host driver is also affected by the same issue:
> > 
> > On Thursday 25 October 2007, Ralf Baechle wrote:
> > >   CC      drivers/ide/pci/generic.o
> > > drivers/ide/pci/generic.c:52: error: __setup_str_ide_generic_all_on causes a
> > > +section type conflict
> > 
> > [ Also reported by Martijn Uffing <mp3project@sarijopen.student.utwente.nl>. ]
> > 
> > This patch workarounds the problem in a bit hackish way but without
> > removing const from generic_chipsets[] (it adds const to __setup() so
> > __setup_str_ide_generic_all becomes const).
> 
> You wouldn't believe how much const data is not marked as const because
> we don't have __constinitdata etc. Literally megabytes.

The gain from marking it const is very little and once any non-const
__initdata object is added to a compilation unit all other const declarations
will have to be removed.  Bad tradeoff.

  Ralf

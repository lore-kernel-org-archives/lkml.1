Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbXKASni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbXKASni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbXKASn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:43:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:61416 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbXKASn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rU/YZ5M2M3G906zkX8fSsXsVkLUNT8J25GUgkX8H2wYhU56mMK/gcA0X0roYne6XMKWHN0lISAK6eADlDqlQ8sOlNmke9YnO7WQhLPb08eDCECV8G4Yd7AT7x3UsSyHGzQ9f11lWcFrGvMxah5Jw6pJHSB0w1BR1+Y2QYVsfSRA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [IDE] Fix build bug
Date: Thu, 1 Nov 2007 18:43:16 +0000
User-Agent: KMail/1.9.1
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org,
       Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
References: <20071025135334.GA23272@linux-mips.org> <200710301134.30087.vda.linux@googlemail.com> <20071030124155.GA7582@linux-mips.org>
In-Reply-To: <20071030124155.GA7582@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711011843.16894.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007 12:41, Ralf Baechle wrote:
> On Tue, Oct 30, 2007 at 11:34:29AM +0000, Denys Vlasenko wrote:
> 
> > On Thursday 25 October 2007 22:41, Bartlomiej Zolnierkiewicz wrote:
> > > > -static const struct ide_port_info generic_chipsets[] __devinitdata = {
> > > > +static struct ide_port_info generic_chipsets[] __devinitdata = {
> > > >  	/*  0 */ DECLARE_GENERIC_PCI_DEV("Unknown",	0),
> > > >  
> > > >  	{	/* 1 */
> > > 
> > > I would prefer to not remove const from generic_chipsets[] so:
> > > 
> > > [PATCH] drivers/ide/pci/generic: fix build for CONFIG_HOTPLUG=n
> > > 
> > > It turns out that const and __{dev}initdata cannot be mixed currently
> > > and that generic IDE PCI host driver is also affected by the same issue:
> > > 
> > > On Thursday 25 October 2007, Ralf Baechle wrote:
> > > >   CC      drivers/ide/pci/generic.o
> > > > drivers/ide/pci/generic.c:52: error: __setup_str_ide_generic_all_on causes a
> > > > +section type conflict
> > > 
> > > [ Also reported by Martijn Uffing <mp3project@sarijopen.student.utwente.nl>. ]
> > > 
> > > This patch workarounds the problem in a bit hackish way but without
> > > removing const from generic_chipsets[] (it adds const to __setup() so
> > > __setup_str_ide_generic_all becomes const).
> > 
> > You wouldn't believe how much const data is not marked as const because
> > we don't have __constinitdata etc. Literally megabytes.
> 
> The gain from marking it const is very little and once any non-const
> __initdata object is added to a compilation unit all other const declarations
> will have to be removed.  Bad tradeoff.

We can intrduce new, ro sections or teach gcc that combining const objects into
non-ro sections is not a crime. I wonder why it currently disallows that.
(And it does it only _somethimes_, const pointers happily go into rw sections!)
--
vda

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbXJ3Lew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbXJ3Lew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXJ3Len
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:34:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:47596 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbXJ3Lem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=aMiRP1tzXYdwBbBgy3rX4NDArsMVTiJN0fFQNIV3gd79lDtjZ1eQi5UQ80lCbT+T+/+RHHMCqIb3oE3XguIcsMrh9vM6pnqpNkGG15N1NS56wqB1l9A1i7uMU83F6141csf6KuN5Gp5WxkeGcjLCHwdOp+r+kI3T2pNkObWg4l0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [IDE] Fix build bug
Date: Tue, 30 Oct 2007 11:34:29 +0000
User-Agent: KMail/1.9.1
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org,
       Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
References: <20071025135334.GA23272@linux-mips.org> <200710252341.38902.bzolnier@gmail.com>
In-Reply-To: <200710252341.38902.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301134.30087.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 22:41, Bartlomiej Zolnierkiewicz wrote:
> > -static const struct ide_port_info generic_chipsets[] __devinitdata = {
> > +static struct ide_port_info generic_chipsets[] __devinitdata = {
> >  	/*  0 */ DECLARE_GENERIC_PCI_DEV("Unknown",	0),
> >  
> >  	{	/* 1 */
> 
> I would prefer to not remove const from generic_chipsets[] so:
> 
> [PATCH] drivers/ide/pci/generic: fix build for CONFIG_HOTPLUG=n
> 
> It turns out that const and __{dev}initdata cannot be mixed currently
> and that generic IDE PCI host driver is also affected by the same issue:
> 
> On Thursday 25 October 2007, Ralf Baechle wrote:
> >   CC      drivers/ide/pci/generic.o
> > drivers/ide/pci/generic.c:52: error: __setup_str_ide_generic_all_on causes a
> > +section type conflict
> 
> [ Also reported by Martijn Uffing <mp3project@sarijopen.student.utwente.nl>. ]
> 
> This patch workarounds the problem in a bit hackish way but without
> removing const from generic_chipsets[] (it adds const to __setup() so
> __setup_str_ide_generic_all becomes const).

You wouldn't believe how much const data is not marked as const because
we don't have __constinitdata etc. Literally megabytes.
--
vda

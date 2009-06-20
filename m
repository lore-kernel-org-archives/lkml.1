Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbZFTS0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbZFTS0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbZFTS0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:26:16 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47019 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbZFTS0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:26:15 -0400
Date: Sat, 20 Jun 2009 12:26:17 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: jim owens <jowens@hp.com>, Martin Knoblauch <knobi@knobisoft.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, efault@gmx.de,
       viro@zeniv.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, mike.miller@hp.com, linux-pci@vger.kernel.org
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
Message-ID: <20090620182617.GM19977@parisc-linux.org>
References: <488605.71443.qm@web32605.mail.mud.yahoo.com> <20090527133125.c36381b5.akpm@linux-foundation.org> <ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com> <170150.72851.qm@web32604.mail.mud.yahoo.com> <20090616122547.1323d2d4@jbarnes-g45> <971371.70253.qm@web32604.mail.mud.yahoo.com> <4A3D104E.9060105@hp.com> <20090620165853.GL19977@parisc-linux.org> <ac3eb2510906201119r5c528a3s67cd04bdbfdd1d9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510906201119r5c528a3s67cd04bdbfdd1d9c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 08:19:43PM +0200, Kay Sievers wrote:
> On Sat, Jun 20, 2009 at 18:58, Matthew Wilcox<matthew@wil.cx> wrote:
> 
> > but I don't know what udev is doing. ??The udev source doesn't seem to
> > read PCI vpd itself:
> >
> > udev-0.141$ find -type f |xargs grep -il vpd
> > ./extras/volume_id/lib/adaptec_raid.c
> > ./extras/scsi_id/scsi_id.8
> > ./extras/scsi_id/scsi.h
> > ./extras/scsi_id/scsi_id.config
> > ./extras/scsi_id/scsi_serial.c
> >
> > so there must be some script that it's invoking which is doing that.
> > Anyone familiar with udev?
> 
> scsi_id is usually also called for cciss devices:
>   KERNEL=="cciss*", ..., IMPORT{program}="scsi_id ...

yes, but it's getting SCSI VPD (by asking for mode pages from the SCSI
device).  This problem is with PCI VPD which is totally different.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

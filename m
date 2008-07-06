Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYGFTXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYGFTXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 15:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbYGFTXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 15:23:42 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45788 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755485AbYGFTXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 15:23:41 -0400
Subject: Re: [BUG]  linux-next: Tree for March 25 kernel oops, when loading
	mpt fusion driver - regression
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Teigland <teigland@redhat.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       Eric.Moore@lsi.com, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20080626203857.GB3815@redhat.com>
References: <20080325175224.3ee62b09.sfr@canb.auug.org.au>
	 <47E9F0B0.4060006@linux.vnet.ibm.com>  <20080626203857.GB3815@redhat.com>
Content-Type: text/plain
Date: Sun, 06 Jul 2008 14:23:35 -0500
Message-Id: <1215372215.4197.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 15:38 -0500, David Teigland wrote:
> On Wed, Mar 26, 2008 at 12:14:00PM +0530, Kamalesh Babulal wrote:
> > Hi Stephen,
> > 
> > Kernel bug is hit while booting up the next-20080325 kernel with MPT
> > Fusion driver built in.This was reported previously for the
> > next-20080320 kernel
> > http://marc.info/?l=linux-next&m=120601013920868&w=2
> 
> Hi, did you ever get this fixed?  I've been having the same problem,
> http://marc.info/?l=linux-scsi&m=121061780821823&w=4
> still exists on 2.6.26-rc8 for me,
> 
> Loading scsi_transport_spi.ko module
> Loading mptscsih.ko module
> Loading mptspi.ko module
> Fusion MPT SPI Host driver 3.04.06
> ACPI: PCI Interrupt 0000:86:01.0[A] -> GSI 32 (level, low) -> IRQ 32
> mptbase: ioc0: Initiating bringup
> ioc0: LSI53C1030 B2: Capabilities={Initiator,Target}
> mptbase: ioc0: PCI-MSI enabled

I speculate that this might be related to the problem.  The fusion
driver was recently flipped to default to MSI enable (previously it had
disabled them).  Could you boot it with the fusion module parameter

mpt_msi_enable=0

if it actually boots that will be a good confirmation that MSI is to
blame.

> mptbase: ioc0: Initiating recovery

This I suspect is because of a lost interrupt.

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000948

And this one looks to be a second bug:  The MSI fault path is actually
causing this oops.

James



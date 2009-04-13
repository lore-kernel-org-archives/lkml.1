Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZDMPiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZDMPiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 11:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZDMPiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 11:38:04 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45057 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752569AbZDMPiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 11:38:01 -0400
Subject: Re: Implementing NVMHCI...
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0904130747440.4583@localhost.localdomain>
References: <20090412091228.GA29937@elte.hu>
	 <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net>
	 <20090412162018.6c1507b4@lxorguk.ukuu.org.uk> <49E213AE.4060506@redhat.com>
	 <alpine.LFD.2.00.0904120950050.4583@localhost.localdomain>
	 <49E2DC96.6090407@redhat.com>
	 <alpine.LFD.2.00.0904130747440.4583@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 10:38:02 -0500
Message-Id: <1239637082.3278.36.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 08:10 -0700, Linus Torvalds wrote:
> On Mon, 13 Apr 2009, Avi Kivity wrote:
> > > Of course, the _really_ conclusive thing (in a virtualized environment) is
> > > to just make the virtual disk only able to do 16kB IO accesses (and with
> > > 16kB alignment). IOW, actually emulate a disk with a 16kB hard sector size,
> > > and reporting a 16kB sector size to the READ CAPACITY command. If it works
> > > then, then clearly WNT has no issues with bigger sectors.
> > 
> > I don't think IDE supports this?  And Windows 2008 doesn't like the LSI
> > emulated device we expose.
> 
> Yeah, you'd have to have the OS use the SCSI commands for disk discovery, 
> so at least a SATA interface. With IDE disks, the sector size always has 
> to be 512 bytes, I think.

Actually, the latest ATA rev supports different sector sizes in
preparation for native 4k sector size SATA disks (words 117-118 of
IDENTIFY).  Matthew Wilcox already has the patches for libata ready.

James



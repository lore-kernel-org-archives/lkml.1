Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbZC3S6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbZC3S6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZC3S5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:57:51 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:32660 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZC3S5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:57:50 -0400
Subject: Re: Linux 2.6.29
From: Chris Mason <chris.mason@oracle.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <49D111C9.4020502@rtr.ca>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
	 <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>
	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>
	 <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed>
	 <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx>
	 <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx>
		 <49D0AA4A.6020308@redhat.com> <49D0CDBA.7040702@rtr.ca>
		 <49D0D08E.3090100@redhat.com> <49D0DAD3.6030507@rtr.ca>
		 <49D0DDFE.5080701@redhat.com> <49D0E35E.9080003@rtr.ca>
		 <49D0E4E8.20508@redhat.com>
	 <alpine.LFD.2.00.0903300841420.3948@localhost.localdomain>
	 <49D0F399.5010407@rtr.ca>
	 <alpine.LFD.2.00.0903300946050.3948@localhost.localdomain>
	 <1238435832.30488.83.camel@think.oraclecorp.com>  <49D111C9.4020502@rtr.ca>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 14:52:29 -0400
Message-Id: <1238439149.20607.12.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49D114F2.02E0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 14:39 -0400, Mark Lord wrote:
> Chris Mason wrote:
> >
> > I had some fun trying things with this, and I've been able to reliably
> > trigger stalls in write cache of ~60 seconds on my seagate 500GB sata
> > drive.  The worst I saw was 214 seconds.
> ..
> 
> I'd be more interested in how you managed that (above),
> than the quite different test you describe below.
> 
> Yes, different, I think.  The test below just times how long a single
> chunk of data might stay in-drive cache under constant load,
> rather than how long it takes to flush the drive cache on command.
> 
> Right?
> 
> Still, useful for other stuff.
> 

That's right, it is testing for starvation in a single sector, not for
how long the cache flush actually takes.  But, your remark from higher
up in the thread was this:

        > 
        > Anything in the drive's write cache very probably made 
        > it to the media within a second or two of arriving there.
        >
        
Sorry if I misread things.  But the goal is just to show that it really
does matter if we use a writeback cache with or without barriers.  The
test has two datasets:

1) An area that is constantly overwritten sequentially
2) A single sector that stores a critical bit of data.

#1 is the filesystem log, #2 is the filesystem super.  This isn't a
specialized workload ;)

-chris



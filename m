Return-Path: <linux-kernel-owner+w=401wt.eu-S933848AbYAaSnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848AbYAaSnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758201AbYAaSnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:43:25 -0500
Received: from mx30.micromemory.com ([67.95.226.74]:1647 "EHLO
	mail.micromemory.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757021AbYAaSnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:43:24 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2008 13:43:24 EST
X-Authenticated-Sender: pterry@micromemory.com
X-Return-Path: pterry@micromemory.com
X-Envelope-From: pterry@micromemory.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: RE: [PATCH 4/6] Add multi mport support.
From: Phil Terry <pterry@micromemory.com>
Reply-To: pterry@vmetro.com
To: Wei.Zhang@freescale.com
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ABF87B0B6A38C0458E319AC973ED68AEBD0697@zch01exm26.fsl.freescale.net>
References: <1201689053956-git-send-email-wei.zhang@freescale.com>
	 <12016890621727-git-send-email-wei.zhang@freescale.com>
	 <120168907160-git-send-email-wei.zhang@freescale.com>
	 <12016890773706-git-send-email-wei.zhang@freescale.com>
	 <AF4B8466-C1CE-4FFB-8341-4BFC1CB76116@kernel.crashing.org>
	 <ABF87B0B6A38C0458E319AC973ED68AEBD0677@zch01exm26.fsl.freescale.net>
	 <EC566605-6890-4983-8700-3B15C9EFC1C5@kernel.crashing.org>
	 <F2D2FCC7-D1ED-4DC6-BE7A-EE2755CCE125@kernel.crashing.org>
	 <ABF87B0B6A38C0458E319AC973ED68AEBD0697@zch01exm26.fsl.freescale.net>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 10:35:25 -0800
Message-Id: <1201804525.14266.45.camel@pterry-fc6.micromemory.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 14:30 +0800, Zhang Wei wrote:
>  
> > -----Original Message-----
> > From: Kumar Gala [mailto:galak@kernel.crashing.org] 
> > 
> > On Jan 31, 2008, at 12:15 AM, Kumar Gala wrote:
> > 
> > >
> > > On Jan 30, 2008, at 11:57 PM, Zhang Wei wrote:
> > >
> > >>
> > >>
> > >>> -----Original Message-----
> > >>> From: Kumar Gala [mailto:galak@kernel.crashing.org]
> > >>>
> > >>> On Jan 30, 2008, at 4:30 AM, Zhang Wei wrote:
> > >>>
> > >>>> Change lots of static variable to mport private. And add
> > >>> mport to some
> > >>>> function declaration.
> > >>>
> > >>> Can you explain this patch further.  Its not clear 
> > exactly from this
> > >>> commit message why we are doing this.
> > >>>
> > >>> - k
> > >>
> > >> Sorry about I have a little hurry about it.
> > >>
> > >> The original RapidIO driver suppose there is only one mpc85xx RIO
> > >> controller
> > >> in system. So, some data structures are defined as mpc85xx_rio  
> > >> global,
> > >> such as 'regs_win', 'dbell_ring', 'msg_tx_ring'. Now, I 
> > changed them
> > >> to
> > >> mport's private members. And you can define multi RIO 
> > OF-nodes in dts
> > >> file
> > >> for multi RapidIO controller in one processor, such as PCI/PCI-Ex  
> > >> host
> > >> controllers
> > >> in Freescale's silicon. And the mport operation function 
> > declaration
> > >> should be changed
> > >> to know which RapidIO controller is target.
> > >
> > > thanks, this makes a lot of sense and now reviewing the patch will
> > > make some sense to me :)
> > 
> > when we have multiple ports are the device IDs on the ports intended  
> > to be unique only to a port or unique across all ports?
> > 
> I consider each RIO controller will has its own network, the device IDs
> should be
> unique only in its port network.
Hmmm, I see two cases:

1. I have two mport to two controllers each connected to different
physical fabrics. This system can act as an application bridge between
the two fabrics.

2. I have two mports to two controllers each connected directly or
indirectly to the same fabric. I want to use the extra bandwidth and
load balance and/or have a fall back redundant connection via an
alternate physical connection to the fabric etc.

What should be the rules for allocating the initial IDs to the two
mports to allow system wide enumeration to work in both of the above
cases? 

What do you expect the semantics of higher level addressing to be:
 a pair <mport,id>, where <x,n> is a different device from <y,n>,
 a pair <mport,id>, where <x,n> is the same device as <y,n>,or
 a singleton n, where n is unique and identifies the first routing step
of which controller, x or y, to use.

I smell a can of worms.... :-)

Cheers
Phil

> 
> Cheers!
> Wei
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 
> 



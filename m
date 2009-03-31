Return-Path: <linux-kernel-owner+w=401wt.eu-S1763046AbZCaWFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763046AbZCaWFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbZCaWFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:05:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757250AbZCaWFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:05:22 -0400
Date: Tue, 31 Mar 2009 14:55:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Theodore Tso <tytso@mit.edu>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090331221053.74354735@the-village.bc.nu>
Message-ID: <alpine.LFD.2.00.0903311452590.6474@localhost.localdomain>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx>
 <49D0AA4A.6020308@redhat.com> <alpine.LFD.2.00.0903300817400.3948@localhost.localdomain> <49D0EF1E.9040806@redhat.com> <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain> <20090331221053.74354735@the-village.bc.nu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Mar 2009, Alan Cox wrote:
> 
> How about the far more regular crash case ? We may be pretty reliable but
> we are hardly indestructible especially on random boxes with funky BIOSes
> or low grade hardware builds.

The regular crash case doesn't need to care about the disk write-cache AT 
ALL. The disk will finish the writes on its own long after the kernel 
crashed.

That was my _point_. The write cache on the disk is generally a whole lot 
safer than the OS data cache. If there's a catastrophic software failure 
(outside of the disk firmware itself ;), then the OS data cache is gone. 
But the disk write cache will be written back.

Of course, if you have an automatic and immediate "power-off-on-oops", 
you're screwed, but if so, you have bigger problems anyway. You need to 
wait at _least_ a second or two before you power off.

		Linus

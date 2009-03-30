Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbZC3TOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbZC3TOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbZC3TN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:13:56 -0400
Received: from edu.joroinen.fi ([194.89.68.130]:59996 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbZC3TNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:13:55 -0400
X-Greylist: delayed 1142 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2009 15:13:55 EDT
Date: Mon, 30 Mar 2009 21:54:49 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Chris Mason <chris.mason@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mark Lord <lkml@rtr.ca>,
       Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090330185449.GD24960@edu.joroinen.fi>
References: <49D0CDBA.7040702@rtr.ca> <49D0D08E.3090100@redhat.com> <49D0DAD3.6030507@rtr.ca> <49D0DDFE.5080701@redhat.com> <49D0E35E.9080003@rtr.ca> <49D0E4E8.20508@redhat.com> <alpine.LFD.2.00.0903300841420.3948@localhost.localdomain> <49D0F399.5010407@rtr.ca> <alpine.LFD.2.00.0903300946050.3948@localhost.localdomain> <1238435832.30488.83.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238435832.30488.83.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 01:57:12PM -0400, Chris Mason wrote:
> On Mon, 2009-03-30 at 09:58 -0700, Linus Torvalds wrote:
> > 
> > On Mon, 30 Mar 2009, Mark Lord wrote:
> > >
> > > I spent an entire day recently, trying to see if I could significantly fill
> > > up the 32MB cache on a 750GB Hitach SATA drive here.
> > > 
> > > With deliberate/random write patterns, big and small, near and far,
> > > I could not fill the drive with anything approaching a full second
> > > of latent write-cache flush time.
> > > 
> > > Not even close.  Which is a pity, because I really wanted to do some testing
> > > related to a deep write cache.  But it just wouldn't happen.
> > > 
> > > I tried this again on a 16MB cache of a Seagate drive, no difference.
> > > 
> > > Bummer.  :)
> > 
> > Try it with laptop drives. You might get to a second, or at least hundreds 
> > of ms (not counting the spinup delay if it went to sleep, obviously). You 
> > probably tested desktop drives (that 750GB Hitachi one is not a low end 
> > one, and I assume the Seagate one isn't either).
> 
> I had some fun trying things with this, and I've been able to reliably
> trigger stalls in write cache of ~60 seconds on my seagate 500GB sata
> drive.  The worst I saw was 214 seconds.
> 
> It took a little experimentation, and I had to switch to the noop
> scheduler (no idea why).  
> 

I remember cfq having a bug (or a feature?) that prevents queue depths
deeper than 1.. so with noop you get more ios to the queue. 

-- Pasi

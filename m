Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXFWLwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXFWLwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 07:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXFWLw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 07:52:28 -0400
Received: from 1wt.eu ([62.212.114.60]:3111 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbXFWLw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 07:52:28 -0400
Date: Sat, 23 Jun 2007 13:51:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alberto Gonzalez <info@gnebu.es>
Cc: Tom Spink <tspink@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about fair schedulers
Message-ID: <20070623115144.GY943@1wt.eu>
References: <200706230007.15622.info@gnebu.es> <200706231300.18840.info@gnebu.es> <7b9198260706230405y5c4a173dx82a18fcc14a10272@mail.gmail.com> <200706231326.34918.info@gnebu.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706231326.34918.info@gnebu.es>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 01:26:34PM +0200, Alberto Gonzalez wrote:
> On Saturday 23 June 2007, Tom Spink wrote:
> > Alberto,
> >
> > If you're feeling adventurous, grab the latest kernel and patch it
> > with Ingo's scheduler: CFS.
> >
> > You may be pleasantly surprised.
> 
> Thanks, I might if I have to courage to patch and compile my own kernel :)
> 
> However, I'd also need to change all my applications to set them with the 
> right priority to see the good results, so I think I might just wait until it 
> lands in mainline.
> 
> Just to check if I understood everything correctly:
> 
> The mainline scheduler tries to be smart and guess the priority of each task, 
> and while it mostly hits the nail right in the head, sometimes it hits you 
> right in the thumb.
> 
> Fair schedulers, on the contrary, forget about trying to be smart and just 
> care about being fair, leaving the priority settings to where they belong: 
> applications.
> 
> Is this more or less correct?

It is somewhat correct, except that nothing prevents them from trying to
be even smarter. For instance, your video player consumes some CPU, but
also calls X which itself consumes some CPU. There are tricks to track
what process makes X work so that both share the same slices, generally
resulting in improved smoothness without playing with applications priorities
yet.

It might be worth trying anyway.

Regards,
Willy


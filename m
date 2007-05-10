Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXEJWBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXEJWBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbXEJWBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:01:22 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41825 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758901AbXEJWBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:01:21 -0400
Date: Thu, 10 May 2007 23:34:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: Chaining sg lists for big I/O commands: Question
Message-ID: <20070510213428.GX4163@kernel.dk>
References: <Pine.LNX.4.64.0705090918390.12857@p34.internal.lan> <20070509133830.GV4163@kernel.dk> <Pine.LNX.4.61.0705102040090.6426@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705102040090.6426@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10 2007, Jan Engelhardt wrote:
> On May 9 2007 15:38, Jens Axboe wrote:
> >> I am a mdadm/disk/hard drive fanatic, I was curious:
> >> 
> >> >On i386, we can at most fit 256 scatterlist elements into a page,
> >> >and on x86-64 we are stuck with 128. So that puts us somewhere
> >> >between 512kb and 1024kb for a single IO.
> >> 
> >> How come 32bit is 256 and 64 is only 128?
> >>
> >> I am sure it is something very fundamental/simple but I was curious, I 
> >> would think x86_64 would fit/support more scatterlists in a page.
> >
> >Because of the size of the scatterlist structure. As pointers are bigger
> >on 64-bit archs, the scatterlist structure ends up being bigger. The
> >page size on x86-64 is 4kb, hence the number of structures you can fit
> >in a page is smaller.
> 
> I take it this problem "goes away" on arches with 8KB page_size?

Not really, the 8kb page size just doubles the sg size. On a 64-bit
arch, that would still only get you 1mb IO size.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYKYAOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYKYAOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbYKYAOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:14:14 -0500
Received: from mail.sdinet.de ([78.47.32.153]:57992 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbYKYAON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:14:13 -0500
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2008 19:14:13 EST
Date: Tue, 25 Nov 2008 01:09:02 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Stian Jordet <liste@jordet.net>
cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
In-Reply-To: <1227569808.5039.6.camel@chevrolet>
Message-ID: <alpine.DEB.2.00.0811250057510.27010@aurora.sdinet.de>
References: <1226760254.5089.11.camel@chevrolet>  <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>  <1227476908.32357.5.camel@chevrolet>  <alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>  <1227485956.5145.10.camel@chevrolet> 
 <alpine.DEB.1.10.0811240448570.25866@p34.internal.lan> <1227569808.5039.6.camel@chevrolet>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008, Stian Jordet wrote:

> ma., 24.11.2008 kl. 04.50 -0500, skrev Justin Piszcz:
> > While there still may be something else wrong, the first problem I see is 
> > your sunit and swidth are set to 0.
> > 
> > Please read, a good article on what they are and how to set them:
> > http://www.socalsysadmin.com/
> 
> Oh, this was new to me. But the setting didn't change anything. I can
> copy one large file between the xfs and ext3 disk (both ways), and I get
> speeds between 160 and 200 MB/s. But unpacking the kernel source takes
> between 5 and 10 minutes on the xfs disk, and a mere 15 seconds on the
> ext3... (and it also used to take between 5 and 10 minutes when I had
> xfs on the raid0, so it doesn't seem to be hardware related...)

I had the same problem when I tried it on my laptop (T60) - using it on 
the unencrypted root filesystem (with /usr/src) took ages, using it on 
the LUKS encrypted /home was blasing fast - on the same disk.

This test was some time ago with something like 2.6.20 or 2.6.24 - I 
gave up and reformatted / with ext3 as I needed the machine.

I think barriers were the problem, they seem to cost performance like 
hell, especially for operations with many small files. My laptop used 
barriers for xfs on the direct partition, but not on crypto drivermapper 
mounts.

So perhaps try mounting with nobarrier and see if the speed problem goes 
away - but know that you sacrifice some crash-resilience when doing so.

c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around
it. (John Gilmore on http://www.cygnus.com/~gnu/)

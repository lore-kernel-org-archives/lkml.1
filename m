Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbZCAKYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbZCAKYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 05:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZCAKX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 05:23:58 -0500
Received: from mail.openmoko.org ([88.198.124.205]:49378 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZCAKX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 05:23:57 -0500
Date: Sun, 1 Mar 2009 15:53:35 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       Andy Green <andy@openmoko.com>
Subject: Re: [PATCH 0/2] spi: Add support for non-blocking synchronous
	transfers
Message-ID: <20090301102333.GD3103@fedora.yogi>
References: <20090228081036.31964.80618.stgit@fedora.yogi> <200902281519.55341.david-b@pacbell.net> <20090301051103.GA3103@fedora.yogi> <200903010149.19845.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903010149.19845.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 01:49:19AM -0800, David Brownell wrote:
> On Saturday 28 February 2009, Balaji Rao wrote:
> > > That leaves un-answered the question of what to do when
> > > the SPI bus is busy performing some other transfer.  I
> > > looked at your [2/2] patch, and saw it ignoring that very
> > > basic issue ... this new call will just poke at the bus,
> > > trashing any transfer that was ongoing.
> > 
> > We use s3c24xx_gpio as the master, which is a very simple gpio based
> > bitbang. 
> > 
> > Yes, it is with this intention, interrupts are disabled around the
> > actual bitbang code, so that it completes without being interrupted.
> > Doesn't this guarantee atomicity ?
> 
> Atomicity isn't the issue so much as the fact that if the
> bus is in the middle of some transfer to one device,
> your patch lets another device trash that transmission.
> 
> I don't know how many more times I can say that your
> patches introduce DATA CORRUPTION to the system, but
> it's surely not many more times.

Yes, I get the point now. Sorry for not observing it earlier.

- Balaji

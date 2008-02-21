Return-Path: <linux-kernel-owner+w=401wt.eu-S934468AbYBUVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468AbYBUVBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932523AbYBUVBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:01:13 -0500
Received: from 1wt.eu ([62.212.114.60]:2073 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355AbYBUVBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:01:11 -0500
Date: Thu, 21 Feb 2008 22:00:58 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: David Newall <davidn@davidnewall.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.4: Back-port of pl2303.c from 2.6.24.1
Message-ID: <20080221210058.GA27541@1wt.eu>
References: <479A83DE.8020002@davidnewall.com> <20080202074406.GA31516@1wt.eu> <47A46BF8.6030306@davidnewall.com> <47BDDD4E.1080000@davidnewall.com> <20080221203640.GA21764@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221203640.GA21764@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Hi David,

On Thu, Feb 21, 2008 at 12:36:40PM -0800, Greg KH wrote:
> On Fri, Feb 22, 2008 at 06:51:34AM +1030, David Newall wrote:
> > Hi Willy,
> > 
> > Lacking hardware for a week, I've had a bit of a hiatus from PL2303, but
> > I've got it back again now, and finished my work back-porting the 2.6
> > driver to 2.4.  Here's a new patch, which is more complete than my
> > previous one.  It's based on the 2.6.24.1.
> > 
> > There's a lot of trivial white-space changes and some things that have
> > been moved, which make the patch rather larger than it could be.  I
> > didn't include those changes before, but have now in order that the
> > driver be closer to the 2.6 driver.  It'll never be identical, of course.
> > 
> > Note, too, that the 2.6 driver (and thus the patched 2.4) includes a 1k
> > circular buffer which rather duplicates a buffer in the 2.4 usbserial.c;
> > 2.6's usb-serial has had that buffer removed.  As the buffer resolves
> > loss of the occasional putchar (e.g. from n_tty's opost), it is
> > important and correct, even in 2.4.
> > 
> > Speaking as a user, I no longer see any problems with PL2303, and I
> > think this is okay to release.
> 
> If this works for you, I have no objection to it, but I can't test it as
> I don't run 2.4 on anything anymore :)

I too agree to merge, it especially since it fixed several problems
for David. However, I would like to know first if the same problems
also happen with the 2.6 driver or if it is OK. The risk is getting
2.4 fixed and not 2.6, which could cause regressions for people upgrading
from 2.4 to 2.6. Of course, a regression on a USB-serial adapter is
not dramatic, but it's a general principle to keep in mind that 2.6
should be safe (or at least actively being fixed) when merging driver
changes in 2.4.

Thanks,
Willy


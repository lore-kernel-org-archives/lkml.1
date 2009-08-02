Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbZHBTiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbZHBTiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZHBTiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:38:06 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:54869 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZHBTiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:38:05 -0400
X-Greylist: delayed 1670 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2009 15:38:05 EDT
Date: Sun, 2 Aug 2009 21:08:51 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Michael S. Zick" <lkml@morethan.org>, linux-kernel@vger.kernel.org
Subject: Re: [VIA Support]  Instruction timing and cache coherency issues
Message-ID: <20090802190851.GZ4216@prithivi.gnumonks.org>
References: <200907250827.43400.lkml@morethan.org>
 <20090730090804.GE1364@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090730090804.GE1364@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 11:08:04AM +0200, Pavel Machek wrote:

> > Diddling with the things I have found that either "fix" or "work around"
> > the various timing / cache coherency issues - - -
> > Aw, so - found how to affect the timing issues sufficiently so that Linux
> > would panic dump rather than deadlock on the troublesum combination - -
> > *Functionally the same* panic backtrace that FreeBSD is showing.
> > 
> > @H.W.  Download the FreeBSD-8.0-beta2 and try running it on your Cloudbook
> > and HP-2133, you can see what is happening.  Then you might have a word or
> > two with the silicon growers.
> > 
> So... you believe you have pinpointed bug in their cpu design?

I would not preclude that, but I think what might be more likely is that there
is some difference between how Intel and how VIA/Centaur behaves in a certain
situation, or the compiler making a wrong assumption about what it can do or
cannot do (remember e.g. for the VIA C3 there was no cmpxchg8, but gcc uses
it in case you compile with i686 optiomization).

I have not yet tried FreeBSD 8 on the cloudbook, but expect to have time during
the next days.  However, since I am not familiar with the FreeBSD kernel
architecture, I would definitely prefer something where I can reproduce the
problem on Linux.

Michael has indicated that he can now crash (oops) the kernel rather than deadlock.
With which kernel is that?  I would love to give that one a try.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbYLFUzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbYLFUzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 15:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYLFUzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 15:55:32 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:27141 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbYLFUzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 15:55:31 -0500
Message-ID: <f73f7ab80812061255t25924931u8c9a3367e8b8159c@mail.gmail.com>
Date: Sat, 6 Dec 2008 15:55:29 -0500
From: "Kyle Moffett" <kyle@moffetthome.net>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: Have the velociraptors in a test system now, checkout the errors.
Cc: "Michael Tokarev" <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       smartmontools-support@lists.sourceforge.net
In-Reply-To: <alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan>
	 <493A5E62.1020508@msgid.tls.msk.ru>
	 <alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2008 at 7:11 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> As far the PSU, just btw/FYI, Velociraptors consume ~4-5 watts a piece, my
> entire system used ~100-120watts with all 12 velociraptors on a 650 watt PSU
> (now moved into a test system).

You should actually break it down further than that.  During system
development recently, the company I work for was using some 350W PSUs
with funny connectors patched in place of the standard molex to drive
the 5V power for some small embedded system testbeds and their drives.
 We were hard-power-cycling the systems by unplugging them from the
bus and we kept having problems with the *other* embedded board
resetting when we did so.  Turns out the "350W" PSU was only rated to
supply 100W to the 5V leads, and our 55W systems (40W for board and
15W for drive) were a little too far past the edge.

In addition, most hard drives, motherboards, etc have circuits powered
separately from the 3.3V, 5V, and 12V busses.  If your *load* is
balanced too heavily on one or the other of the supplies, you can see
extremely weird problems.  When the 12V-powered spindle and
spindle-controller on your HDD loses power but the 5V-powered SATA or
SAS interface does not, its internal state machine gets all kinds of
messed up.  If you can get ahold of one, I'd recommend finding an
oscilliscope to hook up to the 5V and 12V lines into those drives.

Cheers,
Kyle Moffett

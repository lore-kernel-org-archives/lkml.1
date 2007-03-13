Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbXCMHm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbXCMHm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 03:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbXCMHm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 03:42:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43578
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753185AbXCMHmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 03:42:25 -0400
Date: Tue, 13 Mar 2007 00:42:24 -0700 (PDT)
Message-Id: <20070313.004224.41634994.davem@davemloft.net>
To: medwards.linux@gmail.com
Cc: alan@lxorguk.ukuu.org.uk, 7eggert@gmx.de, dada1@cosmosbay.com,
       linux-kernel@vger.kernel.org
Subject: Re: sys_write() racy for multi-threaded append?
From: David Miller <davem@davemloft.net>
In-Reply-To: <f2b55d220703130025l48ea2e8ci15ddf0563cf21bf9@mail.gmail.com>
References: <f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
	<20070313022430.57503b08@lxorguk.ukuu.org.uk>
	<f2b55d220703130025l48ea2e8ci15ddf0563cf21bf9@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael K. Edwards" <medwards.linux@gmail.com>
Date: Mon, 12 Mar 2007 23:25:48 -0800

> Quality means the devices you ship now keep working in the field, and
> the probable cost of later rework if the requirements change does not
> exceed the opportunity cost of over-engineering up front.  Economy
> gets a look-in too, and says that it's pointless to delay shipment and
> bloat the application coding for cases that can't happen.  If POSIX
> says that any and all writes (except small pipe/FIFO writes, whatever)
> can return a short byte count -- but you know damn well you're writing
> to a device driver that never, ever writes short, and if it did you'd
> miss a timing budget recovering from it anyway -- to hell with POSIX.

You're not even safe over standard output, simply run the program over
ssh and you suddenly have socket semantics to deal with.

In the early days the fun game to play was to run programs over rsh to
see in what amusing way they would explode.  ssh has replaced rsh in
this game, but the bugs have largely stayed the same.

Even early versions of tar used to explode on TCP half-closes and
whatnot.

In short, if you don't handle short writes, you're writing a program
for something other than unix.

We're not changing write() to interlock with other parallel callers or
messing with the f_pos semantics in such cases, that's stupid, please
cope, kthx.

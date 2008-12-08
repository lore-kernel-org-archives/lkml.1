Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYLHD4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYLHD4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 22:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbYLHD4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 22:56:13 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:57536 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbYLHD4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 22:56:12 -0500
Message-ID: <ac3eb2510812071956i3630476esf9e95a0bb7f9ca8e@mail.gmail.com>
Date: Mon, 8 Dec 2008 04:56:10 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: Valdis.Kletnieks@vt.edu
Subject: Re: Runaway loop with the current git.
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Evgeniy Polyakov" <zbr@ioremap.net>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-kernel@vger.kernel.org,
       "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
In-Reply-To: <34909.1228706592@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	 <20081207160921.693f637a@lxorguk.ukuu.org.uk>
	 <20081207163151.GA31838@ioremap.net>
	 <20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
	 <ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
	 <20081207172855.55fee78f@lxorguk.ukuu.org.uk>
	 <ac3eb2510812070939h17ef6316hea96fe89f01207a6@mail.gmail.com>
	 <20081207175118.09c633e8@lxorguk.ukuu.org.uk>
	 <ac3eb2510812071022le85080aiea301609fa8a50b1@mail.gmail.com>
	 <34909.1228706592@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2008 at 04:23,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sun, 07 Dec 2008 19:22:41 +0100, Kay Sievers said:
>
>> We are _not_ loading a console driver that way, we try to load the
>> console device itself, not the driver. There is no driver for 5:1 in
>> any module.

[childish blurb removed]

> It doesn't really matter if it's a "console driver" or "the console device
> itself".  If you're in modprobe loading *any* piece of "all the stuff needed
> to make open("/dev/console") work", the last thing you want to be doing
> is opening /dev/console to complain about something not working.

Nothing in initramfs or userspace tries to load "all the stuff needed
to make open("/dev/console") work". It's the kernel itself, that tries
to resolve its own requirements.

The kernel forked binary _writes_ to /dev/console, if we like it or
not, it seems to do that, and it's arguable why it should not, or how
it should detect that it is not allowed to do that. You may just
depend on the logging of binaries to find other bugs.

The helper was called in the first place for something else, in this
case the "cryptomgr". The loop is caused entirely by the kernel
itself, if /dev/console is just accessed. There is no intentional
loading of any console driver from userspace happening here.

Kay

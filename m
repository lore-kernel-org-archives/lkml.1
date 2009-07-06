Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbZGFFa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbZGFFa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 01:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZGFFaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 01:30:20 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:1294 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbZGFFaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 01:30:19 -0400
X-IronPort-AV: E=Sophos;i="4.42,355,1243828800"; 
   d="scan'208";a="1113655"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 2/2] usb_serial: only allow sysrq on a console port
Date: Mon, 6 Jul 2009 01:33:41 -0400
User-Agent: KMail/1.9.5
CC: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, greg@kroah.com,
       "Jason Wessel" <jason.wessel@windriver.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <1243622057-17671-1-git-send-email-jason.wessel@windriver.com> <200907060038.18323.rgetz@blackfin.uclinux.org> <8bd0f97a0907052156m44483903i9b2f35428d1bbe62@mail.gmail.com>
In-Reply-To: <8bd0f97a0907052156m44483903i9b2f35428d1bbe62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907060133.41756.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 06 Jul 2009 05:30:22.0235 (UTC) FILETIME=[DB75C6B0:01C9FDFA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 6 Jul 2009 00:56, Mike Frysinger pondered:
> On Mon, Jul 6, 2009 at 00:38, Robin Getz wrote:
> > It appears that the usb serial doesn't handle breaks like serial_core
> > does. (I  don't see any support for SAK in usb_serial either?)
> >
> > Maybe _that_ is the real problem that Jason is trying to work around???
> 
> perhaps, but what Jason proposed originally sounds pretty sane.

Which is why Greg added it to the USB tree, and it is in 2.6.31-rc2 :)

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=568d422e9cf52b7b26d2e026ae1617971f62b560

> if i 
> enable sysrq support on my desktop, i dont want some development board
> being able to send a sysrq request back over my serial port and
> rebooting my desktop.

Fixing something in the wrong place -- while noble -- is still wrong :)

However -- with the way that usb serial is structured - I didn't see a better 
place right now either.

The point being that is would be nice to make usb serial look more like other 
serial devices - so they can share mode code - and things like this (that 
have been in serial_core.h since -pre-git history (2005) wouldn't just be 
getting added to the usb serial infrastructure now)...




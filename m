Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbXCFTc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbXCFTc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933287AbXCFTc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:32:28 -0500
Received: from mail.tnnet.fi ([217.112.240.26]:49006 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933262AbXCFTc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:32:27 -0500
Message-ID: <45EDC1C3.548EB915@users.sourceforge.net>
Date: Tue, 06 Mar 2007 21:32:19 +0200
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: markus reichelt <ml@mareichelt.de>
Cc: emin ak <eminak71@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: encrypting jffs2 filesystem with DM-crypt or what else?
References: <2cf1ee820703060405l1cd30bf1o896910341bb8f293@mail.gmail.com> <20070306130524.GG4168@tatooine.rebelbase.local>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

markus reichelt wrote:
> * emin ak <eminak71@gmail.com> wrote:
> > I need to encrypt a jffs2/mtd formatted flash filesystem for an
> > embedded device, Normally using a loopback interface (cryptoloop,
> > DM-crypt or loop-aes) solves this problem but they are not well
> > known on journalling file systems (like jffs2) because of cached
> > write etc.. Also I could'nt find any guideline for encrypting
> > fikesystem on a flash.
> 
> device-backed loops are ok, file-based once aren't. The cache issue
> you talk about concerns writing caches of HDDs f.e., I haven't seen a
> flash device with writing cache. However, in most cases writing cache
> can be turned off.

Flash devices behave differently than hard disks. If I remember correcly,
bits can be flipped in one direction (set or reset) without erasing whole
block, but flipping a bit in reverse direction requires that whole block be
erased first.

If jffs2 takes advantage of this one-direction-bit-flipping, then adding
encryption layer between jffs2 and flash device makes it completely
different game that is guaranteed to require lots of flash block erases that
wears down the device much faster than expected.

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD

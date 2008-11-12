Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbYKLH4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbYKLH4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 02:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYKLH4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 02:56:35 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:35433 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYKLH4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 02:56:35 -0500
Date: Wed, 12 Nov 2008 08:56:31 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: mac80211.h (was: Re: linux-next: Tree for November 12)
In-Reply-To: <20081112182818.6e259488.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0811120854290.13217@anakin>
References: <20081112182818.6e259488.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008, Stephen Rothwell wrote:
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

http://kisskb.ellerman.id.au/kisskb/buildresult/54400/

include/net/mac80211.h:400: error: size of array 'type name' is negative
include/net/mac80211.h:405: error: size of array 'type name' is negative

| struct ieee80211_tx_info {
| 	/* common information */
| 	u32 flags;
| 	u8 band;
| 
| 	u8 antenna_sel_tx;
| 
| 	/* 2 byte hole */
        ^^^^^^^^^^^^^^^^^^

This must be made explicit using padding, as on some architecture the alignment
of 32-bit values is 2 bytes, not 4.

| 	union {

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

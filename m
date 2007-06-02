Return-Path: <linux-kernel-owner+w=401wt.eu-S1762855AbXFBToS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762855AbXFBToS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760793AbXFBToJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:44:09 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:39751 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174AbXFBToI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:44:08 -0400
Date: Sat, 2 Jun 2007 12:43:22 -0700
From: Jouni Malinen <j@w1.fi>
To: Adrian Bunk <bunk@stusta.de>
Cc: Dan Williams <dan.j.williams@intel.com>, mingo@redhat.com, neilb@suse.de,
       "John W. Linville" <linville@tuxdriver.com>, linux-raid@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: multiple xor_block() functions
Message-ID: <20070602194321.GB31754@jm.kir.nu>
References: <20070602185746.GI5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070602185746.GI5500@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2007 at 08:57:46PM +0200, Adrian Bunk wrote:
> include/linux/raid/xor.h:extern void xor_block(unsigned int count, unsigned int bytes, void **ptr);
> drivers/md/xor.c:xor_block(unsigned int count, unsigned int bytes, void **ptr)
> drivers/md/xor.c:EXPORT_SYMBOL(xor_block);
> 
> and
> 
> net/ieee80211/ieee80211_crypt_ccmp.c:static inline void xor_block(u8 * b, u8 * a, size_t len)
> 
> 
> At least one of them has to be renamed.

Why? Not that I would really mind renaming one of these, but I don't see
a good reason for it. ieee80211_crypt_ccmp.c should not include
linux/raid/xor.h and the xor_block() in CCMP code is a static inline
function that should not show up outside the scope of this file. Do we
have some magic that makes exported symbols pollute name space for
inlined helper functions?

-- 
Jouni Malinen                                            PGP id EFC895FA

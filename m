Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbYKDP6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbYKDP6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbYKDP5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 10:57:45 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:57414 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968AbYKDP5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 10:57:43 -0500
Subject: Re: [PATCH] jffs2: Fix race condition in jffs2_lzo_compress()
From: Richard Purdie <rpurdie@openedhand.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0811031714590.6298@vixen.sonytel.be>
References: <Pine.LNX.4.64.0811031714590.6298@vixen.sonytel.be>
Content-Type: text/plain
Date: Tue, 04 Nov 2008 15:57:40 +0000
Message-Id: <1225814260.5433.13.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-11-03 at 17:17 +0100, Geert Uytterhoeven wrote:
> deflate_mutex protects the globals lzo_mem and lzo_compress_buf. However,
> jffs2_lzo_compress() unlocks deflate_mutex _before_ it has copied out the
> compressed data from lzo_compress_buf. Correct this by moving the mutex unlock
> after the copy.
> In addition, document what deflate_mutex actually protects.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Acked-by: Richard Purdie <rpurdie@linux.intel.com>

This should probably be queued as a bugfix for the current -rc series.

> ---
> Just noticed this when looking at the code.
> The patch is untested, except for a quick compile test.
> 
>  fs/jffs2/compr_lzo.c |   15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 



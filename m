Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZKQHxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZKQHxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbZKQHxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:53:22 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:34944 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbZKQHxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:53:21 -0500
Message-ID: <4B02565C.1030406@s5r6.in-berlin.de>
Date: Tue, 17 Nov 2009 08:53:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, 504391@bugs.debian.org,
       Wouter van Heyst <larstiq@larstiq.dyndns.org>,
       Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc: add module parameter to set whether cards are assumed
 removable
References: <1257914676.2237.57.camel@localhost>	 <20091116122329.847916b6.akpm@linux-foundation.org> <1258410709.2792.9.camel@localhost>
In-Reply-To: <1258410709.2792.9.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
> In general, it is not possible to tell whether a card present in an MMC
> slot after resume is the same that was there before suspend.

That's true for virtually all storage devices, not just MMC.

> So there are two possible behaviours, each of which will cause data
> loss in some cases:
> 
> CONFIG_MMC_UNSAFE_RESUME=n (default): Cards are assumed to be removed
> during suspend.  Any filesystem on them must be unmounted before
> suspend; otherwise, buffered writes will be lost.
> 
> CONFIG_MMC_UNSAFE_RESUME=y: Cards are assumed to remain present during
> suspend.  They must not be swapped during suspend; otherwise, buffered
> writes will be flushed to the wrong card.
> 
> Currently the choice is made at compile time and this allows that to be
> overridden at module load time.

Can't the kernel flush the write buffer at suspend time, so that you can
remove this choice for good?
-- 
Stefan Richter
-=====-==--= =-== =---=
http://arcgraph.de/sr/

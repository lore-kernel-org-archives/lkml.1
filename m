Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbXFKXP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbXFKXP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbXFKXPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:15:12 -0400
Received: from terminus.zytor.com ([192.83.249.54]:47831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbXFKXPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:15:10 -0400
Message-ID: <466DD696.8080901@zytor.com>
Date: Mon, 11 Jun 2007 16:11:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6> <45BF3954.8050106@yahoo.com.au> <Pine.LNX.4.64.0701300753170.23302@CPE00045a9c397f-CM001225dbafb6> <Pine.LNX.4.61.0701301512200.1147@yvahk01.tjqt.qr> <Pine.LNX.4.64.0701300938580.24147@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0701300938580.24147@CPE00045a9c397f-CM001225dbafb6>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> 
> seriously, though, there is the potential of breaking something with
> this change since you can see how there is some inconsistency in how
> it's done *now* just for powerpc which, in some places, defines its
> own versions of this:
> 
> ./arch/ppc/mm/pgtable.c:
> 	#define is_power_of_2(x) ((x) != 0 && (((x) & ((x) - 1)) == 0))
> ./arch/ppc/syslib/ppc85xx_rio.c:
> 	#define is_power_of_2(x) (((x) & ((x) - 1)) == 0)
> ./arch/powerpc/mm/pgtable_32.c:
> 	#define is_power_of_2(x) ((x) != 0 && (((x) & ((x) - 1)) == 0))
> 
> note how the first and third macros *won't* consider zero a power of
> two, while the second one *will*.  hence the need for a single
> standard for all of this, just to play it safe.
> 

I suspect the reason the test for zero was omitted is because the author
didn't want the extra cost (the test for zero needs an extra branch on a
lot of architectures.)

	-hpa

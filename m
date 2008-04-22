Return-Path: <linux-kernel-owner+w=401wt.eu-S1762024AbYDVDSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762024AbYDVDSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 23:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756224AbYDVDS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 23:18:26 -0400
Received: from sandeen.net ([209.173.210.139]:27596 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666AbYDVDSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 23:18:25 -0400
Message-ID: <480D5900.2000106@sandeen.net>
Date: Mon, 21 Apr 2008 22:18:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: David Chinner <dgc@sgi.com>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] xfs: use smaller int param in call to xfs_flush_pages
References: <20080419142329.GA5339@elte.hu> <200804220433.04030.vda.linux@googlemail.com> <200804220503.16888.vda.linux@googlemail.com> <200804220514.45191.vda.linux@googlemail.com>
In-Reply-To: <200804220514.45191.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> Hi David,
> 
> xfs_flush_pages() flags parameter is declared as uint64_t, but
> code never pass values which do not fit into 32 bits.
> All callsites sans one pass zero, and the last one passes
> XFS_B_DELWRI, XFS_B_ASYNC or zero.
> These values are defined in enum xfs_buf_flags_t and they
> all fit in 32 bits.
> 
> This patch changes type of the parameter and one variable
> which used to pass it to unsigned int.


FWIW this one also seems to make no stack difference, at least on x86_64.

Not complaining; just checking it out. :)

If you can shink xfs_bmapi, let me know.  :)

Thanks,
-Eric

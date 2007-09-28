Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbXI1VU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbXI1VU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbXI1VUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:20:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59388
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753147AbXI1VUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:20:16 -0400
Date: Fri, 28 Sep 2007 14:20:15 -0700 (PDT)
Message-Id: <20070928.142015.82358847.davem@davemloft.net>
To: pl@dlh.net
Cc: sparclinux@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH: tcp rfc 2385 security/bugfix for sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <23966.84.62.25.8.1191012145.squirrel@cs1.dlh.net>
References: <23966.84.62.25.8.1191012145.squirrel@cs1.dlh.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Peter Lieven" <pl@dlh.net>
Date: Fri, 28 Sep 2007 22:42:25 +0200 (CEST)

> TCP MD5 signatures on sparc64 (big-endian) completely fail on current
> kernel releases in interoperability with Cisco/Foundry or other
> little-endian linux systems.
> 
> The root cause is a cast in the return statement of tcp_v4_md5_do_lookup,
> where a tcp4_md5sig_key is casted onto tcp_md5sig_key without proper
> conversion. On little-endian systems the upper 8 bits are cut of which
> yields the expected behaviour. However, on big-endian systems (like
> sparc64) only the most significant 8 bits are preserved. Since
> TCP_MD5SIG_MAXKEYLEN is 80, this always yields 0.
> 
> In the calculation of the md5 signature afterwards the key is therefore
> not appended to the tcp segment which could result in a security problem
> since only the presence of a md5 signature is checked, and the key itself
> doesn't matter.

Thanks for finding this bug.

> --- linux.old/include/net/tcp.h 2007-09-28 21:43:26.000000000 +0200 +++
> linux/include/net/tcp.h     2007-09-28 21:45:35.000000000 +0200 @@ -1055,6
> +1055,7 @@ static inline void clear_all_retrans_hin

I'll have to apply this patch by hand because your email client
completely corrupted the patch.

> Signed-off-by: Peter Lieven <pl@dlh.net>
> Signed-off-by: Matthias M. Dellweg <2500@gmx.de>

Thanks again.

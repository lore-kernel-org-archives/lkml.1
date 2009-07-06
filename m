Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZGFKw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZGFKw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 06:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbZGFKwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 06:52:16 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:52565 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757716AbZGFKwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 06:52:15 -0400
Date: Mon, 6 Jul 2009 18:52:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: sk_lock: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W}
	usage
Message-ID: <20090706105216.GA19124@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608023757.GA6244@localhost>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> This lockdep warning appears when doing stress memory tests over NFS.
> 
> page reclaim => nfs_writepage => tcp_sendmsg => lock sk_lock
> 
> tcp_close => lock sk_lock => tcp_send_fin => alloc_skb_fclone => page reclaim

Well perhaps not this particular path, but it is certainly possible
if an existing NFS socket dies and NFS tries to reestablish it.

I suggest that NFS should utilise the sk_allocation field and
set an appropriate value.  Note that you may have to patch TCP
so that it uses sk_allocation everywhere necessary, e.g., in
tcp_send_fin.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

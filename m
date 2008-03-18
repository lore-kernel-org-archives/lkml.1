Return-Path: <linux-kernel-owner+w=401wt.eu-S1763570AbYCSVAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763570AbYCSVAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759598AbYCSTt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:49:59 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:34730 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228AbYCSTt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:49:57 -0400
Date: Tue, 18 Mar 2008 19:59:14 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com
Subject: Re: dst cache overflow
Message-ID: <20080318185914.GA9275@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-net@vger.kernel.org,
	linux-kernel@vger.kernel.org, dada1@cosmosbay.com
References: <20071214172945.GA10809@yamamaya.is-a-geek.org> <E1J3QWn-0006sJ-00@gondolin.me.apana.org.au> <20071215100857.GA29839@yamamaya.is-a-geek.org> <20071216073533.GA2706@gondor.apana.org.au> <20071216083828.GA512@yamamaya.is-a-geek.org> <20080317012513.GA3139@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080317012513.GA3139@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:

> just a reminder, the server is now running 2.6.24 and the leak is
> still there.  I noticed there is a slab leak debug option and turned
> it on, results should be visible in a few days I guess.

Current (20080318 19:42) biggest net-related numbers:

skbuff_head_cache: 1614 __alloc_skb+0x29/0x108
ip_dst_cache: 1579 dst_alloc+0x25/0x5f
skbuff_fclone_cache: 965 __alloc_skb+0x29/0x108
size-512: 895 sock_wmalloc+0x2b/0x4d
TCPv6: 856 sk_clone+0x14/0x16a
size-2048: 733 tcp_sendmsg+0x174/0x9fc
size-512: 279 sock_alloc_send_skb+0x7c/0x193
size-512: 238 tcp_send_ack+0x2a/0xec
size-512: 223 tcp_send_fin+0x60/0x12e
sock_inode_cache: 172 sock_alloc_inode+0x10/0x4e
size-1024: 147 sock_alloc_send_skb+0x7c/0x193


ranma@oni:~$ netstat -6 -an | wc -l
29

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。

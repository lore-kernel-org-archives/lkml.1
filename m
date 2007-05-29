Return-Path: <linux-kernel-owner+w=401wt.eu-S1765679AbXE2UKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765679AbXE2UKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762554AbXE2UKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:10:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57125
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757390AbXE2UKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:10:00 -0400
Date: Tue, 29 May 2007 13:10:13 -0700 (PDT)
Message-Id: <20070529.131013.97289989.davem@davemloft.net>
To: rpjday@mindspring.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: dead CONFIG_ variables: net/ipv4/
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705021711450.16967@localhost.localdomain>
References: <Pine.LNX.4.64.0705021711450.16967@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Robert P. J. Day" <rpjday@mindspring.com>
Date: Wed, 2 May 2007 17:15:01 -0400 (EDT)

> 
>   again, this list contains some CONFIG_ variables that aren't
> technically dead, but *really* should be renamed to not be confused
> with Kconfig variables.  there are, however, legitimately dead ones in
> the following in places:
> 
> $ ../dead_config.sh net/ipv4
> ========== IP_FIB_TRIE_STATS ==========
> net/ipv4/fib_trie.c:#undef CONFIG_IP_FIB_TRIE_STATS
> net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> net/ipv4/fib_trie.c:#endif /*  CONFIG_IP_FIB_TRIE_STATS */

Robert Olsson uses this for statistics collection by turning
that #undef there into a #define and other developers could
use this too.

Therefore I'm reluctant to remove this for now.

> ========== IP_NOSIOCRT ==========
> net/ipv4/fib_frontend.c:#ifndef CONFIG_IP_NOSIOCRT

Definitely bogus, deleted.

> ========== IP_PIMSM ==========
> net/ipv4/ipmr.c:#define CONFIG_IP_PIMSM 1

This one isn't bogus, it is a shorthand and is set when
either CONFIG_IP_PIMSM_V1 or CONFIG_IP_PIMSM_V2 are set.

> ========== IP_ROUTE_PERVASIVE ==========
> net/ipv4/fib_semantics.c:#ifdef CONFIG_IP_ROUTE_PERVASIVE

This seems to be for an intended feature to allow control of
recursive gateway lookups, I'm not touching this one :-)

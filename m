Return-Path: <linux-kernel-owner+w=401wt.eu-S1765849AbXE2UP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765849AbXE2UP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbXE2UPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:15:50 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:52625 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXE2UPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:15:50 -0400
X-Originating-Ip: 72.143.65.211
Date: Tue, 29 May 2007 16:14:30 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: dead CONFIG_ variables: net/ipv4/
In-Reply-To: <20070529.131013.97289989.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0705291611460.6478@localhost.localdomain>
References: <Pine.LNX.4.64.0705021711450.16967@localhost.localdomain>
 <20070529.131013.97289989.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, David Miller wrote:

> From: "Robert P. J. Day" <rpjday@mindspring.com>
> Date: Wed, 2 May 2007 17:15:01 -0400 (EDT)
>
> >
> >   again, this list contains some CONFIG_ variables that aren't
> > technically dead, but *really* should be renamed to not be confused
> > with Kconfig variables.  there are, however, legitimately dead ones in
> > the following in places:
> >
> > $ ../dead_config.sh net/ipv4
> > ========== IP_FIB_TRIE_STATS ==========
> > net/ipv4/fib_trie.c:#undef CONFIG_IP_FIB_TRIE_STATS
> > net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> > net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> > net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> > net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> > net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> > net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> > net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> > net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> > net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> > net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> > net/ipv4/fib_trie.c:#ifdef CONFIG_IP_FIB_TRIE_STATS
> > net/ipv4/fib_trie.c:#endif /*  CONFIG_IP_FIB_TRIE_STATS */
>
> Robert Olsson uses this for statistics collection by turning
> that #undef there into a #define and other developers could
> use this too.
>
> Therefore I'm reluctant to remove this for now.

there's lots of that sort of thing in the kernel -- the only point i'd
make is that it seems typical to reserve the prefix "CONFIG_" strictly
for those variables that are set via Kconfig files.  it just makes the
namespace cleaner, that's all.  otherwise, that variable is going to
come up continually in any script like mine that's searching for
possible dead Kconfig variables.

> > ========== IP_PIMSM ==========
> > net/ipv4/ipmr.c:#define CONFIG_IP_PIMSM 1

as is this one, etc, etc.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

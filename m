Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbXJAJv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbXJAJv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 05:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXJAJvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:51:19 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42496 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbXJAJvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:51:18 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 1 Oct 2007 05:48:59 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: roel <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] removes array_size duplicates
In-Reply-To: <20071001022653.40bd5714.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710010546340.15688@localhost.localdomain>
References: <46FC33E1.8010309@tiscali.nl> <20071001022653.40bd5714.akpm@linux-foundation.org>
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

On Mon, 1 Oct 2007, Andrew Morton wrote:

> On Fri, 28 Sep 2007 00:51:13 +0200 roel <12o3l@tiscali.nl> wrote:
>
> > This patch removes some ARRAY_SIZE macro duplicates. There is also one in
> > arch/um/include/user.h, which isn't fixed here because comments in that file
> > explicitly state a preference for the 'less fancy' version. If that's the
> > case as well for any of the other replacements please comment.
>
> I got a bunch of rejects against various development trees, a
> build error in net/ipv4/ipvs/ip_vs_proto_udp.c and now
>
> net/netfilter/xt_sctp.c: In function 'match_packet':
> net/netfilter/xt_sctp.c:58: error: size of array 'type name' is negative
> net/netfilter/xt_sctp.c:106: error: size of array 'type name' is negative

among other things, one of the creepy issues here is the definition in
include/linux/netfilter/xt_sctp.h of the macro:

...
#define SCTP_CHUNKMAP_COPY(destmap, srcmap)                     \
        do {                                                    \
                int i;                                          \
                for (i = 0; i < ELEMCOUNT(chunkmap); i++)       \
                        destmap[i] = srcmap[i];                 \
        } while (0)
...

  i'm not a big fan of macros that refer to objects that aren't
parameters to the macro, especially when all the rest of them *do*.

rday

p.s.  ELEMCOUNT is simply an alternative to ARRAY_SIZE, which could
certainly be rewritten that way.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================

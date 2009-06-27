Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbZF0WYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbZF0WYj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 18:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZF0WYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 18:24:20 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:47101 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZF0WYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 18:24:19 -0400
Date: Sun, 28 Jun 2009 00:00:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Patrick McHardy <kaber@trash.net>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] headers_check fix: linux/netfilter/xt_osf.h
Message-ID: <20090627220007.GB2719@uranus.ravnborg.org>
References: <1246120264.32198.2.camel@hpdv5.satnam> <20090627175209.GA12453@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090627175209.GA12453@ioremap.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 09:52:09PM +0400, Evgeniy Polyakov wrote:
> Hi.
> 
> On Sat, Jun 27, 2009 at 10:01:04PM +0530, Jaswinder Singh Rajput (jaswinder@kernel.org) wrote:
> > fix the following 'make headers_check' warnings:
> > 
> >   usr/include/linux/netfilter/xt_osf.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> 
> Looks good, thank you.
> Patrick, please apply.

What about the other potential issues in the same file?
struct xt_osf_opt {
        __u16                   kind, length;
        struct xt_osf_wc        wc;
};

Do we know that struct xt_osf_wc is always aligned at a two byte
address also on 64 bit?
Do we know that sizeof(struct xt_osf_opt) is the same
on all platforms?

struct xt_osf_user_finger {
        struct xt_osf_wc        wss;

        __u8                    ttl, df;
        __u16                   ss, mss;
        __u16                   opt_num;

        char                    genre[MAXGENRELEN];
        char                    version[MAXGENRELEN];
        char                    subtype[MAXGENRELEN];

        /* MAX_IPOPTLEN is maximum if all options are NOPs or EOLs */
        struct xt_osf_opt       opt[MAX_IPOPTLEN];
};

Do we know that opt[MAX_IPOPTLEN] always start at the same offset
with different architectures?

struct xt_osf_nlmsg {
        struct xt_osf_user_finger       f;
        struct iphdr            ip;
        struct tcphdr           tcp;
};

We do not knwo struct iphdr/tcphdr - missing include.
Do we know the alignment of the above structs?
Are they always the same on all archs?

	Sam

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZF1J4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZF1J4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 05:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZF1J4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 05:56:45 -0400
Received: from cs-studio.ru ([195.178.208.66]:50428 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbZF1J4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 05:56:44 -0400
Date: Sun, 28 Jun 2009 13:56:37 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Patrick McHardy <kaber@trash.net>, David Miller <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] headers_check fix: linux/netfilter/xt_osf.h
Message-ID: <20090628095637.GA651@ioremap.net>
References: <1246120264.32198.2.camel@hpdv5.satnam> <20090627175209.GA12453@ioremap.net> <20090627220007.GB2719@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090627220007.GB2719@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 12:00:07AM +0200, Sam Ravnborg (sam@ravnborg.org) wrote:
> What about the other potential issues in the same file?
> struct xt_osf_opt {
>         __u16                   kind, length;
>         struct xt_osf_wc        wc;
> };
> 
> Do we know that struct xt_osf_wc is always aligned at a two byte
> address also on 64 bit?

Why 2 bytes? It is 4 bytes aligned everywhere everytime.

> Do we know that sizeof(struct xt_osf_opt) is the same
> on all platforms?

Yes.

> struct xt_osf_user_finger {
>         struct xt_osf_wc        wss;
> 
>         __u8                    ttl, df;
>         __u16                   ss, mss;
>         __u16                   opt_num;
> 
>         char                    genre[MAXGENRELEN];
>         char                    version[MAXGENRELEN];
>         char                    subtype[MAXGENRELEN];
> 
>         /* MAX_IPOPTLEN is maximum if all options are NOPs or EOLs */
>         struct xt_osf_opt       opt[MAX_IPOPTLEN];
> };
> 
> Do we know that opt[MAX_IPOPTLEN] always start at the same offset
> with different architectures?

Yes.

> struct xt_osf_nlmsg {
>         struct xt_osf_user_finger       f;
>         struct iphdr            ip;
>         struct tcphdr           tcp;
> };
> 
> We do not knwo struct iphdr/tcphdr - missing include.
> Do we know the alignment of the above structs?
> Are they always the same on all archs?

You won't believe...

-- 
	Evgeniy Polyakov

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZF1FSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZF1FSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 01:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZF1FSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 01:18:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:33624 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbZF1FSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 01:18:38 -0400
Subject: Re: [PATCH] headers_check fix: linux/netfilter/xt_osf.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Patrick McHardy <kaber@trash.net>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090627220007.GB2719@uranus.ravnborg.org>
References: <1246120264.32198.2.camel@hpdv5.satnam>
	 <20090627175209.GA12453@ioremap.net>
	 <20090627220007.GB2719@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 10:48:17 +0530
Message-Id: <1246166297.4497.6.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-28 at 00:00 +0200, Sam Ravnborg wrote:
> On Sat, Jun 27, 2009 at 09:52:09PM +0400, Evgeniy Polyakov wrote:
> > Hi.
> > 
> > On Sat, Jun 27, 2009 at 10:01:04PM +0530, Jaswinder Singh Rajput (jaswinder@kernel.org) wrote:
> > > fix the following 'make headers_check' warnings:
> > > 
> > >   usr/include/linux/netfilter/xt_osf.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>
> > > 
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > 
> > Looks good, thank you.
> > Patrick, please apply.
> 
> What about the other potential issues in the same file?
> struct xt_osf_opt {
>         __u16                   kind, length;
>         struct xt_osf_wc        wc;
> };
> 
> Do we know that struct xt_osf_wc is always aligned at a two byte
> address also on 64 bit?
> Do we know that sizeof(struct xt_osf_opt) is the same
> on all platforms?
> 
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
> 
> struct xt_osf_nlmsg {
>         struct xt_osf_user_finger       f;
>         struct iphdr            ip;
>         struct tcphdr           tcp;
> };
> 
> We do not knwo struct iphdr/tcphdr - missing include.
> Do we know the alignment of the above structs?
> Are they always the same on all archs?
> 

If you want to fix it, then send it in different patch.

Do not mix up things, Please.

--
JSR




Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYHDNxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYHDNxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYHDNxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:53:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41231 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYHDNxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:53:20 -0400
Subject: Re: [patch 4/4] Configure out IGMP support
From: David Woodhouse <dwmw2@infradead.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       netdev@vger.kernel.org, davem@davemloft.net, akpm@linux-foundation.org
In-Reply-To: <20080804144807.6b2374d9@surf>
References: <20080731092703.661994657@free-electrons.com>
	 <20080731093221.565015353@free-electrons.com>
	 <1217619715.3454.488.camel@pmac.infradead.org>
	 <20080804144807.6b2374d9@surf>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 04 Aug 2008 14:53:16 +0100
Message-Id: <1217857996.3454.622.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 14:48 +0200, Thomas Petazzoni wrote:
> Le Fri, 01 Aug 2008 20:41:55 +0100,
> David Woodhouse <dwmw2@infradead.org> a écrit :
> 
> > The config option probably lives in net/Kconfig, not init/Kconfig.
> 
> Yes, it could. But AFAIK, until now, all CONFIG_EMBEDDED-related
> options have been put in init/Kconfig. But if it's preferred, I can of
> course change the patch to move the config option to net/Kconfig.

It clearly lives in net/Kconfig.

> > And please could you make it clear how this interacts with
> > IP_MULTICAST?
> > 
> > We already have a CONFIG_IP_MULTICAST option, for which the help text
> > says "For more people, it's safe to say N'. And I think it defaults to
> > that too. What more does CONFIG_IGMP remove? It's not made clear by
> > the help text.
> 
> The interaction of IGMP support with CONFIG_IP_MULTICAST is fairly
> unclear to me.
> 
> A large portion of igmp.c is already under #ifdef CONFIG_IP_MULTICAST:
> all the igmp_*() functions, amongst which is igmp_rcv(), referenced in
> igmp_protocol in net/ipv4/af_inet.c, which is compiled-out
> when !CONFIG_IP_MULTICAST.
> 
> All the proc-related code at the end of the file is only conditionnaly
> compiled on CONFIG_PROC_FS, but seems to in fact be only used if both
> CONFIG_IP_MULTICAST and CONFIG_PROC_FS are selected:
> igmp_mc_proc_init() in net/ipv4/ip_output.c is only called when
> CONFIG_IP_MULTICAST and CONFIG_PROC_FS are selected.
> 
> Besides that, it's unclear to me why the ip_mc_*() functions are useful
> when !CONFIG_IP_MULTICAST, but I'm probably missing something. 

Most of them aren't, as far as I can tell. 

> They are used to implement setsockopt-operations related to multicast,
> hooks for the routing code to handle multicast-related traffic, etc.

I wonder if those options should return errors now, rather than silently
failing but returning zero. Or maybe that _would_ cause a stock build of
ntpd to fail? Not that it really matters if it _does_, though.

It sounds like 'CONFIG_IGMP' is a bad name for the option, too -- and
the help text is similarly misleading. I think you need to work out how
it all fits together with CONFIG_IP_MULTICAST, fix it up, and resubmit
it.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation




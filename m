Return-Path: <linux-kernel-owner+w=401wt.eu-S1030347AbXBZROh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030347AbXBZROh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030345AbXBZROh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:14:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030347AbXBZROg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:14:36 -0500
Message-ID: <45E31572.4040108@redhat.com>
Date: Mon, 26 Feb 2007 12:14:26 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: netfilter-devel@lists.netfilter.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com> <45E04468.7020001@trash.net> <45E06546.504@redhat.com> <45E1C7E0.9070102@trash.net>
In-Reply-To: <45E1C7E0.9070102@trash.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Chuck Ebbert wrote:
> 
> Can you try this patch please?
> ------------------------------------------------------------------------
> 
> [NETFILTER]: conntrack: fix {nf,ip}_ct_iterate_cleanup endless loops
> 

>  include/linux/netfilter_ipv4/ip_conntrack.h  |    5 ++--
>  include/net/netfilter/nf_conntrack.h         |    5 +++-
>  include/net/netfilter/nf_nat_rule.h          |    3 ++
>  net/ipv4/netfilter/ip_conntrack_core.c       |   30 ++++++++++++++++++------
>  net/ipv4/netfilter/ip_conntrack_standalone.c |    5 ++--
>  net/ipv4/netfilter/ip_nat_core.c             |    5 ++--
>  net/ipv4/netfilter/ipt_MASQUERADE.c          |    4 ++-
>  net/ipv4/netfilter/nf_nat_core.c             |    7 ++----
>  net/netfilter/nf_conntrack_core.c            |   33 ++++++++++++++++++++------
>  net/netfilter/nf_conntrack_proto.c           |    4 ++-
>  10 files changed, 69 insertions(+), 32 deletions(-)
> 

Changes to nf_nat_core.c, ip_nat_core.c and nf_conntrack_proto.c
do not apply, and nf_conntrack_core.c changes are already there.

This is vanilla 2.6.20; looks like there have been a bunch
of changes since then.  I tried adding all of the RCU patches
but even they won't apply.

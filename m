Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbYJ1FG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbYJ1FG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYJ1FGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:06:19 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1898 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYJ1FGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:06:18 -0400
Subject: Re: [RFC PATCH 3/5] net/ipv4, net/ipv6: use %#p6, %p6 format
 strings
From: Joe Perches <joe@perches.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Miller <davem@davemloft.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1225166718.5526.18.camel@brick>
References: <1225166718.5526.18.camel@brick>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 22:05:38 -0700
Message-Id: <1225170338.5269.127.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0-2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 21:05 -0700, Harvey Harrison wrote:
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index eea9542..113c4d9 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -2986,9 +2986,8 @@ static void if6_seq_stop(struct seq_file *seq, void *v)
>  static int if6_seq_show(struct seq_file *seq, void *v)
>  {
>  	struct inet6_ifaddr *ifp = (struct inet6_ifaddr *)v;
> -	seq_printf(seq,
> -		   NIP6_SEQFMT " %02x %02x %02x %02x %8s\n",
> -		   NIP6(ifp->addr),
> +	seq_printf(seq, "%#p6 %02x %02x %02x %02x %8s\n",
> +		   &ifp->addr,
>  		   ifp->idev->dev->ifindex,
>  		   ifp->prefix_len,
>  		   ifp->scope,

Is it really necessary to change the formats and arguments?

Perhaps it's enough to change the defines to:

#define NIP6_FMT "%6p"
#define NIP6_SEQFMT "%#6p"
#define NIP6(addr) &(addr)

If not, I think the NIP6 and NIP6_SEQFMT should be
separate patchsets for ease of verification.


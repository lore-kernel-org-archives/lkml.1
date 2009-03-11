Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZCKOsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZCKOsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbZCKOrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:47:49 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:21837 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbZCKOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:47:48 -0400
Message-ID: <49B7CEF2.2000409@hp.com>
Date: Wed, 11 Mar 2009 10:47:14 -0400
From: Brian Haley <brian.haley@hp.com>
Organization: Open Source and Linux Organization
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: John Dykstra <john.dykstra1@gmail.com>
CC: Thomas Backlund <tmb@mandriva.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: BUG when unloading bonding on 2.6.29-rc7-git3
References: <49B6CA4A.2040506@mandriva.org> <1236727393.7958.38.camel@Maple>
In-Reply-To: <1236727393.7958.38.camel@Maple>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Dykstra wrote:
> ipv6:  Fix BUG when disabled ipv6 module is unloaded
> 
> Do not try to "uninitialize" ipv6 if its initialization had been skipped
> because module parameter disable=1 had been specified.
> 
> Reported-by:  Thomas Backlund <tmb@mandriva.org>
> Signed-off-by: John Dykstra <john.dykstra1@gmail.com>
> ---
> net/ipv6/af_inet6.c |    3 +++
> 1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index da944ec..a0f1798 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -1192,6 +1192,9 @@ module_init(inet6_init);
> 
> static void __exit inet6_exit(void)
> {
> +       if (disable_ipv6)
> +               return;
> +
>         /* First of all disallow new sockets creation. */
>         sock_unregister(PF_INET6);
>         /* Disallow any further netlink messages */

Acked-by: Brian Haley <brian.haley@hp.com>

Thanks for fixing this John.

Sorry, this was in the original patch I tested here, but somehow didn't make it
into what I sent to Dave.

-Brian

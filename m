Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbXLLGFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbXLLGFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 01:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbXLLGF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 01:05:29 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:1695 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbXLLGF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 01:05:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YWARxAyF65hPhI7lbNpTrTHoA9Fnwf3hdFAqmQLBkkalaKCn55SEPLnJ9HUa/NkQMs6xAfQNUevpbskvL7AN1MTsaxKaTKNok4RBT8wAbbw7W310tmURcE2BlLYW9Lr4TVRsML379iQeX9m0yeLsvj6zfDorr74yNRt9IvbUn6c=
Message-ID: <b25c3fa70712112205l2e778bacx66470606272b199@mail.gmail.com>
Date: Wed, 12 Dec 2007 15:05:26 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [RFC] net: napi fix
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       baum@tehutinetworks.net, andy@greyhouse.net
In-Reply-To: <20071211214634.4dedb274@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <002901c83c73$b089b6e0$9c94fea9@jason>
	 <20071211213939.122de1db@freepuppy.rosehill>
	 <20071211214634.4dedb274@freepuppy.rosehill>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/12, Stephen Hemminger <shemminger@linux-foundation.org>:
> Isn't this a better fix for all drivers, rather than peppering every
> driver with the special case. This is how the logic worked up until
> 2.6.24.
>
>
> --- a/net/core/dev.c    2007-12-11 12:16:20.000000000 -0800
> +++ b/net/core/dev.c    2007-12-11 21:43:39.000000000 -0800
> @@ -2184,7 +2184,7 @@ static void net_rx_action(struct softirq
>
>                have = netpoll_poll_lock(n);
>
> -               weight = n->weight;
> +               weight = min(n->weight, budget);
>
>                /* This NAPI_STATE_SCHED test is for avoiding a race
>                 * with netpoll's poll_napi().  Only the entity which
>

Stephen,
Could you explain how it fix the problem?
IMHO I think your patch cannot solve the problem.
The drivers can call netif_rx_complete and net_rx_action can do
list_move_tail also.
Am I missing something?

Thanks
Joonwoo

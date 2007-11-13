Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbXKMBVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbXKMBVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 20:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbXKMBVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 20:21:44 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:49249 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbXKMBVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 20:21:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BuZsXAWXgpn9pjBCLvg5saNo17owbgAPnlZ130W9v+9sxjIw7pqeQTW9Wh26s0ptTY8zPOfkD7H9kdOzTlDQkgPIzd5d1yX5tBUYenLq3XXnTl4MGopy8lIkw1QTIhprVUHPREu9MUVAM2XxJgXMid8rEJMvyVZImRDVAH8oRWo=
Message-ID: <b25c3fa70711121721i6f5c3f25kd2c02dc5a4cf0dfe@mail.gmail.com>
Date: Tue, 13 Nov 2007 10:21:41 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous mode
Cc: "David Miller" <davem@davemloft.net>, cfriesen@nortel.com, kaber@trash.net,
       auke-jan.h.kok@intel.com, netdev@vger.kernel.org,
       djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
In-Reply-To: <20071112231516.GA15227@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47388B9F.7050308@trash.net>
	 <20071112.143342.10809862.davem@davemloft.net>
	 <4738D70C.4060404@nortel.com>
	 <20071112.145716.06352378.davem@davemloft.net>
	 <20071112231516.GA15227@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/13, Willy Tarreau <w@1wt.eu>:
> On Mon, Nov 12, 2007 at 02:57:16PM -0800, David Miller wrote:
> > From: "Chris Friesen" <cfriesen@nortel.com>
> > Date: Mon, 12 Nov 2007 16:43:24 -0600
> >
> > > David Miller wrote:
> > >
> > > > When you select VLAN, you by definition are asking for non-VLAN
> > > > traffic to be elided.  It is like plugging the ethernet cable
> > > > into one switch or another.
> > >
> > > For max functionality it seems like the raw eth device should show
> > > everything on the wire in promiscuous mode.
> > >
> > > If we want to sniff only the traffic for a specific vlan, we can sniff
> > > the vlan device.
> >
> > VLAN settings are a filter of sorts, much like plugging into
> > one switch or another filters traffic physically.
> >
> > If you don't want that filter, turn the VLAN settings off.
>
> I don't really agree with that view. Having spent a lot of time with
> tcpdump on production systems, I can say that sometimes you'd like to
> be aware that one of your VLANs is wrong and you'd simply like to
> sniff the wire to guess the correct tag. And on production, you simply
> cannot remove other VLANs, otherwise you disrupt the service.
>

I agree.
If I had a mis-plugged cable, I can guess it with tcpdump.
Because I cannot see the packets. It means no such packets on the wire 100%.
But if I had a incorrect vlan configuration, it's hard to sure.
In a case both of mis-plugged and mis-configured situation, I cannot
see anything.
Moreover, if I am configuring a machine via vlan interface which is
mis-configured partially, I cannot disable vlan hw acceleration
feature.

Thanks.
Joonwoo

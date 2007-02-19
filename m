Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbXBSK5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbXBSK5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932068AbXBSK5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:57:00 -0500
Received: from poczta.o2.pl ([193.17.41.142]:59008 "EHLO poczta.o2.pl"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932066AbXBSK47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:56:59 -0500
Date: Mon, 19 Feb 2007 12:00:22 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S\. Miller" <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net/bridge/br_if.c: don't use _WORK_NAR
Message-ID: <20070219110021.GA2190@ff.dom.local>
References: <20070218214359.GA4226@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218214359.GA4226@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 12:43:59AM +0300, Oleg Nesterov wrote:
> Afaics, noautorel work_struct buys nothing for "struct net_bridge_port".
>
> If del_nbp()->cancel_delayed_work(&p->carrier_check) fails, port_carrier_check
> may be called later anyway. So the reading of *work in port_carrier_check() is
> equally unsafe with or without this patch.

I think this _WORK_NAR is to give some additional
control, but also is more logical: it lets to decide
when the work_struct is really release-able (and it's
definitely not before work function is called, as
without noautorel).

So, even if this functionality isn't used now, I can't
see what changing this could buy.

Regards,
Jarek P. 

Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbXBSMDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbXBSMDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 07:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbXBSMDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 07:03:53 -0500
Received: from mail.screens.ru ([213.234.233.54]:45895 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180AbXBSMDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 07:03:52 -0500
Date: Mon, 19 Feb 2007 15:03:53 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net/bridge/br_if.c: don't use _WORK_NAR
Message-ID: <20070219120353.GC91@tv-sign.ru>
References: <20070218214359.GA4226@tv-sign.ru> <20070219110021.GA2190@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070219110021.GA2190@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Jarek Poplawski wrote:
>
> On Mon, Feb 19, 2007 at 12:43:59AM +0300, Oleg Nesterov wrote:
> > Afaics, noautorel work_struct buys nothing for "struct net_bridge_port".
> >
> > If del_nbp()->cancel_delayed_work(&p->carrier_check) fails, port_carrier_check
> > may be called later anyway. So the reading of *work in port_carrier_check() is
> > equally unsafe with or without this patch.
> 
> I think this _WORK_NAR is to give some additional
> control, but also is more logical: it lets to decide
> when the work_struct is really release-able

Sadly, it doesn't help here.

                                              (and it's
> definitely not before work function is called, as
> without noautorel).

kfree() doesn't check WORK_STRUCT_PENDING, it makes no
difference if it is set or not when work->func() runs.

> So, even if this functionality isn't used now, I can't
> see what changing this could buy.

We are going to kill _NAR stuff.

Oleg.


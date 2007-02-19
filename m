Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbXBSL17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbXBSL17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932097AbXBSL17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:27:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086AbXBSL16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:27:58 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070218214359.GA4226@tv-sign.ru> 
References: <20070218214359.GA4226@tv-sign.ru> 
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net/bridge/br_if.c: don't use _WORK_NAR 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 19 Feb 2007 11:27:33 +0000
Message-ID: <8462.1171884453@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Afaics, noautorel work_struct buys nothing for "struct net_bridge_port".

You may be right.

> If del_nbp()->cancel_delayed_work(&p->carrier_check) fails, port_carrier_check
> may be called later anyway.

Called by what?  Something outside of br_if.c?

> So the reading of *work in port_carrier_check() is equally unsafe with or
> without this patch.

Hmmm... cancel_delayed_work() in del_nbp() probably ought to be followed by a
flush_scheduled_work().

David

Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbXBTKpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbXBTKpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 05:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932870AbXBTKpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 05:45:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932869AbXBTKpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 05:45:24 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070219221125.GA5070@tv-sign.ru> 
References: <20070219221125.GA5070@tv-sign.ru>  <20070218214359.GA4226@tv-sign.ru> <8462.1171884453@redhat.com> <20070219115955.GB91@tv-sign.ru> 
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: PATCH? net/bridge/br_if.c: fix use after free in port_carrier_check() 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 20 Feb 2007 10:44:56 +0000
Message-ID: <18581.1171968296@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Oleg Nesterov <oleg@tv-sign.ru> wrote:

>  static void release_nbp(struct kobject *kobj)
>  {
>  	struct net_bridge_port *p
>  		= container_of(kobj, struct net_bridge_port, kobj);
> +
> +	dev_put(p->dev);

Does this need to be done with the mutex held?  And does anything actually pay
attention to the refcount on dev?  I assume not...

Should you clear p->dev->br_port before calling dev_put()?

Looks reasonable.  I like it.

Acked-By: David Howells <dhowells@redhat.com>

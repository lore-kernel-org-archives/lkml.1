Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbZINOHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbZINOHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbZINOHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:07:19 -0400
Received: from kandzendo.ru ([195.178.208.66]:38643 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbZINOHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:07:18 -0400
Date: Mon, 14 Sep 2009 18:07:20 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jamie Lokier <jamie@shareable.org>
Cc: Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
Subject: Re: [PATCH 1/8] networking/fanotify: declare fanotify socket numbers
Message-ID: <20090914140720.GA8564@ioremap.net>
References: <20090911052558.32359.18075.stgit@paris.rdu.redhat.com> <20090911.114620.260824240.davem@davemloft.net> <1252697613.2305.38.camel@dhcp231-106.rdu.redhat.com> <20090911204602.GA19371@shareable.org> <1252703626.2305.50.camel@dhcp231-106.rdu.redhat.com> <20090911212731.GA19901@shareable.org> <1252705902.2305.83.camel@dhcp231-106.rdu.redhat.com> <20090912094110.GB24709@ioremap.net> <20090914001759.GB30621@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914001759.GB30621@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 01:17:59AM +0100, Jamie Lokier (jamie@shareable.org) wrote:
> > When queue is full or you do not have enough RAM. Both are reported at
> > 'sending' time.
> 
> Can you ->poll() and wait reliably until the queue will accept an skb?
> (A few spurious EAGAINs/ENOBUFs is ok, as long as it's not the norm).

Not that simple and for memory allocation error just can't.

There is no direct access to remote peer sockets, i.e. to userspace
ones, so one will have to lock netlink table and run over listeners and
check whether they can accept the message and wait/poll for queue size
to become big enough. Netlink table and its locking is not exported,
so effectively there is no simple way to do this.

-- 
	Evgeniy Polyakov

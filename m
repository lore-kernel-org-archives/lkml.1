Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZIKSqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZIKSqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZIKSqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:46:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54129
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755877AbZIKSqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:46:04 -0400
Date: Fri, 11 Sep 2009 11:46:20 -0700 (PDT)
Message-Id: <20090911.114620.260824240.davem@davemloft.net>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
Subject: Re: [PATCH 1/8] networking/fanotify: declare fanotify socket
 numbers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090911052558.32359.18075.stgit@paris.rdu.redhat.com>
References: <20090911052558.32359.18075.stgit@paris.rdu.redhat.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>
Date: Fri, 11 Sep 2009 01:25:58 -0400

> fanotify's user interface uses a custom socket (it doesn't use netlink
> since work must be done in the context of the receive side of the socket)
> 
> This patch simply defines the fanotify socket number declarations.  The
> actual implementation of the socket is in a later patch.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

I would really prefer if you worked on eliminating the problem that
prevents you from using netlink instead.

You're just duplicating tons of netlink functionality only because of
this apparent limitation, and that's not good.

If you use netlink you'll be able to define arbitrary attributes,
they'll be optional and thus you can allow notification application to
set filters on those attributes, as well as all sorts of other things.

You can reimplement that, but I really would rather see you make
netlink suit your needs.  This is how we make existing facilities
more powerful and useful to consumers, when someone tries to use
it in a new way and with new requirements.

Thanks.

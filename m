Return-Path: <linux-kernel-owner+w=401wt.eu-S1030877AbXDYNtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030877AbXDYNtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030929AbXDYNtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:49:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030877AbXDYNtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:49:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070420.015838.83621529.davem@davemloft.net> 
References: <20070420.015838.83621529.davem@davemloft.net>  <29341.1176975158@redhat.com> <2969.1176992303@redhat.com> <1101.1177056127@redhat.com> 
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, akpm@osdl.org, containers@lists.osdl.org,
       oleg@tv-sign.ru, hch@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Getting the new RxRPC patches upstream 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 25 Apr 2007 14:48:39 +0100
Message-ID: <13634.1177508919@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


David Miller <davem@davemloft.net> wrote:

> Is it possible for your changes to be purely networking
> and not need those changes outside of the networking?

See my latest patchset release.  I've reduced the dependencies on
non-networking changes to:

 (1) Oleg Nesterov's patch to change cancel_delayed_work() to use del_timer()
     rather than del_timer_sync() [patch 02/16].

     This patch can be discarded without compilation failure at the expense of
     making AFS slightly less efficient. It also makes AF_RXRPC slightly less
     efficient, but only in the rmmod path.

 (2) A symbol export in the keyring stuff plus a proliferation of the types
     available in the struct key::type_data union [patch 03/16].  This does
     not conflict with any other patches that I know about.

 (3) A symbol export in the timer stuff [patch 04/16].

Everything else that remains after the reduction is confined to the AF_RXRPC
or AFS code, save for a couple of networking patches in my patchset that you
already have and I just need to make the thing compile.

I'm not sure that I can make the AF_RXRPC patches totally independent of the
AFS patches as the two sets need to interleave since the last AF_RXRPC patch
deletes the old RxRPC code - which the old AFS code depends on.

David

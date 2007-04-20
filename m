Return-Path: <linux-kernel-owner+w=401wt.eu-S1767052AbXDTKmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767052AbXDTKmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767050AbXDTKmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:42:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767049AbXDTKmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:42:18 -0400
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
Date: Fri, 20 Apr 2007 11:41:46 +0100
Message-ID: <4713.1177065706@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> Now that Herbert cleared up the crypto layer issues
> the only problem left is that there are generic changes
> in there which are not strictly networking but which
> your subsequent networking changes depend upon.
>
> This is a mess, and makes merging your work into the
> net-2.6.22 tree more difficult.

There are only two non-net patches that AF_RXRPC depends on:

 (1) The key facility changes.  That's all my code anyway, and shouldn't be a
     problem to merge unless someone else has put some changes in there that I
     don't know about.

 (2) try_to_cancel_delayed_work().  I suppose I could use
     cancel_delayed_work() instead, but that's less efficient as it waits for
     the timer completion function to finish.

And one that AFS depends on:

 (3) Cache the key in nameidata.  I still don't have Al's agreement on this,
     but it's purely caching, so I could drop that patch for the moment and
     excise the stuff that uses it from my AFS patches if that would help.

Do you class the AFS patches as "networking changes"?

Do you want me to consolidate my patches to make things simpler for you?

Do you want me to rebase my patches onto net-2.6.22?

I have the following patches, in order, available now, though I haven't yet
released the last few (they can all be downloaded from my RH people pages):

	move-skb-generic.diff  (you've got this)
	timers.diff
	keys.diff
	af_rxrpc.diff
	afs-cleanup.diff
	af_rxrpc-kernel.diff
	af_rxrpc-afs.diff
	af_rxrpc-delete-old.diff
	af_rxrpc-own-workqueues.diff
	af_rxrpc-fixes.diff
	afs-callback-wq.diff
	afs-vlocation.diff
	afs-multimount.diff
	afs-rxrpc-key.diff
	afs-nameidata-key.diff
	afs-security.diff
	afs-doc.diff
	netlink-support-MSG_TRUNC.diff  (you've got this)
	afs-get-capabilities.diff
	afs-initcallbackstate3.diff
	afs-dir-write-support.diff

David

Return-Path: <linux-kernel-owner+w=401wt.eu-S1030480AbXDKUKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030480AbXDKUKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030476AbXDKUKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:10:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030433AbXDKUKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:10:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070411193844.GC3704@fieldses.org> 
References: <20070411193844.GC3704@fieldses.org>  <20070411190956.15499.55352.stgit@warthog.cambridge.redhat.com> <20070411191037.15499.67852.stgit@warthog.cambridge.redhat.com> 
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 8/8] AFS: Add security support 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 11 Apr 2007 21:10:32 +0100
Message-ID: <18379.1176322232@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> Just curious--when is the actual crypto done?  There doesn't seem to be
> any in this patch.

See AF_RXRPC patch:

	http://people.redhat.com/~dhowells/rxrpc/04-af_rxrpc.diff

You turn on CONFIG_RXKAD and load the rxkad module thus built (assuming you
haven't built it in) after loading the af_rxrpc module.  I probably should've
mentioned that in the cover.

So anyone using sockets of family AF_RXRPC can use it.  See these test
programs:

 (1) The klog test program fetches a ticket from the kaserver and adds it as a
     key of type rxrpc:

	http://people.redhat.com/~dhowells/rxrpc/klog.c

 (2) The listen test program which listens for potentially secured incoming
     calls:

	http://people.redhat.com/~dhowells/rxrpc/listen.c

 (3) The rxrpc test program which can make secure calls:

	http://people.redhat.com/~dhowells/rxrpc/rxrpc.c

David

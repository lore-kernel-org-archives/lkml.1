Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbXFRKn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbXFRKn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759974AbXFRKnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:43:20 -0400
Received: from postel.suug.ch ([194.88.212.233]:38298 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbXFRKnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:43:20 -0400
Date: Mon, 18 Jun 2007 12:43:40 +0200
From: Thomas Graf <tgraf@suug.ch>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: davem@davemloft.net, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
Message-ID: <20070618104340.GZ521@postel.suug.ch>
References: <E1I0CTH-0006k3-00@dorka.pomaz.szeredi.hu> <20070618.021813.105401188.davem@davemloft.net> <E1I0DYW-0006uZ-00@dorka.pomaz.szeredi.hu> <20070618.023520.102546505.davem@davemloft.net> <E1I0DmJ-0006yg-00@dorka.pomaz.szeredi.hu> <20070618103241.GX521@postel.suug.ch> <E1I0EdX-0007Ia-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I0EdX-0007Ia-00@dorka.pomaz.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Miklos Szeredi <miklos@szeredi.hu> 2007-06-18 12:39
> You are wrong.  Look in unix_release_sock():
> 
> 	if (atomic_read(&unix_tot_inflight))
> 		unix_gc();		/* Garbage collect fds */
> 
> 
> unix_tot_inflight is the number of AF_UNIX sockets currently being
> transferred over some AF_UNIX sockets.
> 
> That means that just sending (non-unix socket) fds over unix sockets
> will never invoke the gc.

That's what I meant, I'm sorry, I should have written unix socket
file descriptor to not leave any room for misinterpretation.

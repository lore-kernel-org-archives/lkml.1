Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644Ab0AEUxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0AEUxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426Ab0AEUxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:53:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264Ab0AEUxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:53:43 -0500
Date: Tue, 5 Jan 2010 22:50:40 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] net: packet: option to only pass skb protocol
Message-ID: <20100105205040.GA30921@redhat.com>
References: <20100105185732.GA30346@redhat.com> <4B439299.1090205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B439299.1090205@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 08:27:21PM +0100, Eric Dumazet wrote:
> Le 05/01/2010 19:57, Michael S. Tsirkin a écrit :
> > When sending packets with a packet socket it is often necessary to set
> > protocol in msg_name: otherwise the protocol field in the skb will not
> > be set correctly.  However, currently doing this also requires
> > supplying the interface index.
> > 
> > The following patch makes it possible to avoid supplying the interface
> > index by interpreting index 0 as "use device this socket is bound to".
> > 
> 
> Patch is correct, but I dont understand why zero initialization by caller
> is any better then supplying ifindex (known when socket was bound to device ?)
> 
> To avoid one syscall at socket setup (to get ifindex from dev name),
> you prefer to add a test/branch at each send() syscall...
> 
> Am I missing something ?

binding socket to device might be done by a separate process
from the one doing sendmsg, and IMO the device socket is bound
to might change at any time.

So the sending process would need to get socket name before
each sendmsg.

Makes sense?

-- 
MST

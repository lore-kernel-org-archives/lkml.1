Return-Path: <linux-kernel-owner+w=401wt.eu-S2992516AbXDROLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992516AbXDROLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992557AbXDROLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:11:53 -0400
Received: from mx2.netapp.com ([216.240.18.37]:32591 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992516AbXDROLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:11:53 -0400
X-IronPort-AV: i="4.14,422,1170662400"; 
   d="scan'208"; a="52281332:sNHT18538681"
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Florin Iucha <florin@iucha.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070418134225.GG24044@iucha.net>
References: <1176865565.6796.16.camel@heimdal.trondhjem.org>
	 <20070418033055.GA24044@iucha.net>
	 <1176868485.6796.42.camel@heimdal.trondhjem.org>
	 <20070418040730.GC24044@iucha.net>
	 <20070417211350.ebba1493.akpm@linux-foundation.org>
	 <20070418043040.GD24044@iucha.net>
	 <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org>
	 <20070417223738.8f49a39f.akpm@linux-foundation.org>
	 <20070418123842.GF24044@iucha.net>
	 <1176902131.6796.62.camel@heimdal.trondhjem.org>
	 <20070418134225.GG24044@iucha.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 18 Apr 2007 10:11:46 -0400
Message-Id: <1176905506.6796.84.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 18 Apr 2007 14:11:52.0591 (UTC) FILETIME=[835DB1F0:01C781C3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 08:42 -0500, Florin Iucha wrote:
> On Wed, Apr 18, 2007 at 09:15:31AM -0400, Trond Myklebust wrote:
> > There is only one request on the 'pending' queue. That would usually
> > indicate that the connection to the server is down. Can you check using
> > "netstat -t" whether or not there is a connection in the 'ESTABLISHED'
> > state to the server? Please also repeat the command a couple of times in
> > order to see if the socket/port number on the connection changes.
> 
> This is with your fifth patch on top of the previous four patches:
> 
>    http://iucha.net/nfs/21-rc7-nfs3/big-copy
> 
> Again, it has memory, stack traces and rpc_debug.
> 
> The iostat 5 output:
> 
>    http://iucha.net/nfs/21-rc7-nfs3/iostat
> 
> The netstat outputs are stable (not changed in 5 minutes):
> 
>    http://iucha.net/nfs/21-rc7-nfs3/netstat-server :
> 
> tcp        1      0 hermes.iucha.org:nfs    zeus.iucha.org:799      CLOSE_WAIT 
> tcp        0      0 hermes.iucha.org:nfs    zeus.iucha.org:976      ESTABLISHED
> 
>    http://iucha.net/nfs/21-rc7-nfs3/netstat-client
> 
> Active Internet connections (w/o servers)
> Proto Recv-Q Send-Q Local Address           Foreign Address         State      
> tcp        0      0 zeus.iucha.org:976      hermes.iucha.org:nfs    ESTABLISHED
> tcp        0      0 zeus.iucha.org:ssh      hermes.iucha.org:56880  ESTABLISHED
> tcp        0      0 zeus.iucha.org:ssh      hermes.iucha.org:45176  ESTABLISHED
> 
> Could the port in CLOSE_WAIT state be the culprit?  (FWIW
> the server has been up for 38 days and subjected to
> this nfs test quite a bit without showing any stress).

The port in CLOSE_WAIT shows that a socket was closed down recently, but
once the connection is re-established, the client should start sending
data.
Do you have a copy of wireshark or ethereal on hand? If so, could you
take a look at whether or not any NFS traffic is going between the
client and server once the hang happens?
Note that the timeout value is 60 seconds, so if you see no immediate
traffic, then let the ethereal/wireshark session keep running for a
couple more minutes.

Cheers,
  Trond

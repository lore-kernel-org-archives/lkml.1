Return-Path: <linux-kernel-owner+w=401wt.eu-S1760058AbXHISTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058AbXHISTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbXHISSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:18:31 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:50757 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbXHISSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:18:30 -0400
Date: Thu, 9 Aug 2007 22:18:23 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Unai Uribarri <unai.uribarri@optenet.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] af_packet: don't enable timestamps in mmap'ed sockets
Message-ID: <20070809181823.GA32449@2ka.mipt.ru>
References: <1186669314.24669.56.camel@localhost.localdomain> <20070809143322.GA5345@2ka.mipt.ru> <1186683234.24669.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186683234.24669.65.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 08:13:54PM +0200, Unai Uribarri (unai.uribarri@optenet.com) wrote:
> On jue, 2007-08-09 at 18:33 +0400, Evgeniy Polyakov wrote:
> > On Thu, Aug 09, 2007 at 04:21:54PM +0200, Unai Uribarri (unai.uribarri@optenet.com) wrote:
> > > The attached patch removes the automatic timestamp activation, that
> > > only mmap'ed AF_PACKET sockets perform. I known it can break user
> > > applications, but I believe that it's the correct solution.
> > 
> > How tcpdump with mmap libpcap will work with it?
> 
> In Linux, you can enable timestamps on any socket executing:
> 
> int val = 1;
> setsockopt(sock, SOL_SOCKET, SO_TIMESTAMP, &val, sizeof(val));
> 
> PD: Current release of tcpdump doesn't mmap the reception ring and
> timestamps packets at user space with gettimeofday. It isn't the best
> performing alternative, but it's portable.
 
IIRC, there was/is a libpcap which worked with mapped sockets, mybe not 
official though. Any application which depened on having timestamps with
packets will not work now. Why not to implement an
absolutely_turn_off_timestamps option instead of breaking compatibility?

-- 
	Evgeniy Polyakov

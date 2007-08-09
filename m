Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbXHISo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbXHISo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbXHISo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:44:27 -0400
Received: from ipsec.mad.optenet.com ([213.27.232.70]:38684 "EHLO
	mta-mad.optenet.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbXHISoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:44:23 -0400
Subject: Re: [PATCH 1/1] af_packet: don't enable timestamps in mmap'ed
	sockets
From: Unai Uribarri <unai.uribarri@optenet.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070809181823.GA32449@2ka.mipt.ru>
References: <1186669314.24669.56.camel@localhost.localdomain>
	 <20070809143322.GA5345@2ka.mipt.ru>
	 <1186683234.24669.65.camel@localhost.localdomain>
	 <20070809181823.GA32449@2ka.mipt.ru>
Content-Type: text/plain
Organization: Optenet
Date: Thu, 09 Aug 2007 20:44:21 +0200
Message-Id: <1186685061.24669.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is another option:

1. Move timestampt activation to packet_set_ring(), so it's activated
only once at setup instead of every time a packet arrives.
2. Fix sock_setsockopt() so setting SO_TIMESTAMP to 0 effectively
disables timestamp.

My first patch set did that. I sent that patches in mime multipart
format and they were removed from the list archives. I can resent them
in plain text if needed.


On jue, 2007-08-09 at 22:18 +0400, Evgeniy Polyakov wrote:
> On Thu, Aug 09, 2007 at 08:13:54PM +0200, Unai Uribarri (unai.uribarri@optenet.com) wrote:
> > On jue, 2007-08-09 at 18:33 +0400, Evgeniy Polyakov wrote:
> > > On Thu, Aug 09, 2007 at 04:21:54PM +0200, Unai Uribarri (unai.uribarri@optenet.com) wrote:
> > > > The attached patch removes the automatic timestamp activation, that
> > > > only mmap'ed AF_PACKET sockets perform. I known it can break user
> > > > applications, but I believe that it's the correct solution.
> > > 
> > > How tcpdump with mmap libpcap will work with it?
> > 
> > In Linux, you can enable timestamps on any socket executing:
> > 
> > int val = 1;
> > setsockopt(sock, SOL_SOCKET, SO_TIMESTAMP, &val, sizeof(val));
> > 
> > PD: Current release of tcpdump doesn't mmap the reception ring and
> > timestamps packets at user space with gettimeofday. It isn't the best
> > performing alternative, but it's portable.
>  
> IIRC, there was/is a libpcap which worked with mapped sockets, mybe not 
> official though. Any application which depened on having timestamps with
> packets will not work now. Why not to implement an
> absolutely_turn_off_timestamps option instead of breaking compatibility?
> 



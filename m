Return-Path: <linux-kernel-owner+w=401wt.eu-S938653AbXHJL7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938653AbXHJL7K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 07:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936856AbXHJLzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 07:55:17 -0400
Received: from mta-mad.optenet.com ([213.27.232.70]:54409 "EHLO
	mta-mad.optenet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936829AbXHJLzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 07:55:13 -0400
Subject: Re: [PATCH 1/1] af_packet: don't enable timestamps in mmap'ed
	sockets
From: Unai Uribarri <unai.uribarri@optenet.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070810083418.GA25479@2ka.mipt.ru>
References: <1186669314.24669.56.camel@localhost.localdomain>
	 <20070809143322.GA5345@2ka.mipt.ru>
	 <1186683234.24669.65.camel@localhost.localdomain>
	 <20070809181823.GA32449@2ka.mipt.ru>
	 <1186685061.24669.76.camel@localhost.localdomain>
	 <20070810083418.GA25479@2ka.mipt.ru>
Content-Type: text/plain
Organization: Optenet
Date: Fri, 10 Aug 2007 13:55:07 +0200
Message-Id: <1186746907.24669.107.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On vie, 2007-08-10 at 12:34 +0400, Evgeniy Polyakov wrote:
> Hi Unai.
> 
> On Thu, Aug 09, 2007 at 08:44:21PM +0200, Unai Uribarri (unai.uribarri@optenet.com) wrote:
> > There is another option:
> > 
> > 1. Move timestampt activation to packet_set_ring(), so it's activated
> > only once at setup instead of every time a packet arrives.
> 
> Does this break existing systems which expects timestamp be turned on
> always if there are packet sockets.
> 

Well, current behaviour is that all packets get always timestamped if
the socket has a reception ring. We are just activating it a bit sooner
at the setsockopt(SOL_PACKET, PACKET_RX_RING) call instead of waiting
until the reception of the first packet. And current applications can't
disable it if we use a new socket option. So I can see how an
application can break.

> > 2. Fix sock_setsockopt() so setting SO_TIMESTAMP to 0 effectively
> > disables timestamp.
> 
> This breaks compatibility. Add new socket option, which will really
> disable it and do all your logic, but not breaking existing
> applications.
> 

Is SO_TIMESTAMP2 a valid name? I can't imagine how to call it.





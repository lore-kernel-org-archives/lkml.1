Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbXHXPsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbXHXPsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXHXPrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:47:52 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:60658 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbXHXPru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:47:50 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: akepner@sgi.com
Subject: Re: RFC: issues concerning the next NAPI interface
Date: Fri, 24 Aug 2007 17:47:15 +0200
User-Agent: KMail/1.8.2
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200708241559.17055.ossthema@de.ibm.com> <20070824153703.GN5592@sgi.com>
In-Reply-To: <20070824153703.GN5592@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708241747.16592.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 24 August 2007 17:37, akepner@sgi.com wrote:
> On Fri, Aug 24, 2007 at 03:59:16PM +0200, Jan-Bernd Themann wrote:
> > .......
> > 3) On modern systems the incoming packets are processed very fast. Especially
> >    on SMP systems when we use multiple queues we process only a few packets
> >    per napi poll cycle. So NAPI does not work very well here and the interrupt 
> >    rate is still high. What we need would be some sort of timer polling mode 
> >    which will schedule a device after a certain amount of time for high load 
> >    situations. With high precision timers this could work well. Current
> >    usual timers are too slow. A finer granularity would be needed to keep the
> >    latency down (and queue length moderate).
> > 
> 
> We found the same on ia64-sn systems with tg3 a couple of years 
> ago. Using simple interrupt coalescing ("don't interrupt until 
> you've received N packets or M usecs have elapsed") worked 
> reasonably well in practice. If your h/w supports that (and I'd 
> guess it does, since it's such a simple thing), you might try 
> it.
> 

I don't see how this should work. Our latest machines are fast enough that they
simply empty the queue during the first poll iteration (in most cases).
Even if you wait until X packets have been received, it does not help for
the next poll cycle. The average number of packets we process per poll queue
is low. So a timer would be preferable that periodically polls the 
queue, without the need of generating a HW interrupt. This would allow us
to wait until a reasonable amount of packets have been received in the meantime
to keep the poll overhead low. This would also be useful in combination
with LRO.

Regards,
Jan-Bernd

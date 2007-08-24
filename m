Return-Path: <linux-kernel-owner+w=401wt.eu-S1760647AbXHXQpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbXHXQpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbXHXQpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:45:44 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55230 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbXHXQpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:45:42 -0400
Date: Fri, 24 Aug 2007 11:45:41 -0500
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: netdev <netdev@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: RFC: issues concerning the next NAPI interface
Message-ID: <20070824164541.GG4282@austin.ibm.com>
References: <200708241559.17055.ossthema@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708241559.17055.ossthema@de.ibm.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 03:59:16PM +0200, Jan-Bernd Themann wrote:
> 3) On modern systems the incoming packets are processed very fast. Especially
>    on SMP systems when we use multiple queues we process only a few packets
>    per napi poll cycle. So NAPI does not work very well here and the interrupt 
>    rate is still high. 

I saw this too, on a system that is "modern" but not terribly fast, and
only slightly (2-way) smp. (the spidernet)

I experimented wih various solutions, none were terribly exciting.  The
thing that killed all of them was a crazy test case that someone sprung on
me:  They had written a worst-case network ping-pong app: send one
packet, wait for reply, send one packet, etc.  

If I waited (indefinitely) for a second packet to show up, the test case 
completely stalled (since no second packet would ever arrive).  And if I 
introduced a timer to wait for a second packet, then I just increased 
the latency in the response to the first packet, and this was noticed, 
and folks complained.  

In the end, I just let it be, and let the system work as a busy-beaver, 
with the high interrupt rate. Is this a wise thing to do?  I was
thinking that, if the system is under heavy load, then the interrupt
rate would fall, since (for less pathological network loads) more 
packets would queue up before the poll was serviced.  But I did not
actually measure the interrupt rate under heavy load ... 

--linas

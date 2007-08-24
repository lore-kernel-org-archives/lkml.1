Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbXHXPid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbXHXPid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbXHXPiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:38:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43712 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758721AbXHXPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:38:09 -0400
From: akepner@sgi.com
Date: Fri, 24 Aug 2007 08:37:03 -0700
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: RFC: issues concerning the next NAPI interface
Message-ID: <20070824153703.GN5592@sgi.com>
References: <200708241559.17055.ossthema@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708241559.17055.ossthema@de.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 03:59:16PM +0200, Jan-Bernd Themann wrote:
> .......
> 3) On modern systems the incoming packets are processed very fast. Especially
>    on SMP systems when we use multiple queues we process only a few packets
>    per napi poll cycle. So NAPI does not work very well here and the interrupt 
>    rate is still high. What we need would be some sort of timer polling mode 
>    which will schedule a device after a certain amount of time for high load 
>    situations. With high precision timers this could work well. Current
>    usual timers are too slow. A finer granularity would be needed to keep the
>    latency down (and queue length moderate).
> 

We found the same on ia64-sn systems with tg3 a couple of years 
ago. Using simple interrupt coalescing ("don't interrupt until 
you've received N packets or M usecs have elapsed") worked 
reasonably well in practice. If your h/w supports that (and I'd 
guess it does, since it's such a simple thing), you might try 
it.

-- 
Arthur


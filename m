Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbXHXVfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbXHXVfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbXHXVfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:35:19 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45585 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbXHXVfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:35:16 -0400
Date: Fri, 24 Aug 2007 16:35:14 -0500
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: Bodo Eggert <7eggert@gmx.de>, netdev <netdev@vger.kernel.org>,
       Thomas Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: RFC: issues concerning the next NAPI interface
Message-ID: <20070824213514.GL4282@austin.ibm.com>
References: <8VHRR-45R-17@gated-at.bofh.it> <8VKwj-8ke-27@gated-at.bofh.it> <E1IOeSm-0000bm-Jo@be1.lrz> <20070824204243.GI4282@austin.ibm.com> <46CF499C.60009@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CF499C.60009@de.ibm.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 11:11:56PM +0200, Jan-Bernd Themann wrote:
> (when they are available for
> POWER in our case). 

hrtimer worked fine on the powerpc cell arch last summer.
I assume they work on p5 and p6 too, no ??

> I tried to implement something with "normal" timers, but the result
> was everything but great. The timers seem to be far too slow.
> I'm not sure if it helps to increase it from 1000HZ to 2500HZ
> or more.

Heh. Do the math. Even on 1gigabit cards, that's not enough:

(1gigabit/sec) x (byte/8 bits) x (packet/1500bytes) x (sec/1000 jiffy) 

is 83 packets a jiffy (for big packets, even more for small packets, 
and more again for 10 gigabit cards). So polling once per jiffy is a 
latency disaster.

--linas  


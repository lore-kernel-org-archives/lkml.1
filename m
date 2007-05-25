Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbXEYWMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbXEYWMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbXEYWMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:12:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:40302 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbXEYWMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:12:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,581,1170662400"; 
   d="scan'208";a="232226677"
Message-ID: <46575F5A.1030003@intel.com>
Date: Fri, 25 May 2007 15:12:42 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net <linux-net@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: rmmod e1000 hangs (Was Re: 2.6.22-rc2-mm1)
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <46556AA6.7040503@goop.org> <20070524104713.GA9174@gondor.apana.org.au> <20070524105403.GA9285@gondor.apana.org.au> <4655A4CD.8010901@intel.com> <20070525125413.GA29433@gondor.apana.org.au> <20070525130404.GA30071@gondor.apana.org.au> <20070525133253.GA30626@gondor.apana.org.au>
In-Reply-To: <20070525133253.GA30626@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2007 22:12:43.0931 (UTC) FILETIME=[D1638EB0:01C79F19]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Fri, May 25, 2007 at 11:04:04PM +1000, Herbert Xu wrote:
>> [E1000]: Call netif_poll_enable in e1000_open
> 
> Here is a better one.
> 
> [E1000]: Restore netif_poll_enable call but make sure IRQs are off
> 
> This restores the previously removed netif_poll_enable call in
> e1000_open.  It's needed on all but the first call to e1000_open
> for a NIC as e1000_close always calls netif_poll_disable.
> 
> netif_poll_enable can only be called safely if no polls have been
> scheduled.  This should be the case as long as we don't enter our
> IRQ handler.
> 
> In order to guarantee this we explicitly disable IRQs as early
> as possible when we're probing the NIC.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Ack!

this also fixes all the issues we had seen ourselves. I took a bit of time to 
get our labs to test it.

Who can pick this patch up for us? Jeff ?

Auke

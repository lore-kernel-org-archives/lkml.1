Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbZH0U1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbZH0U1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 16:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbZH0U1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 16:27:09 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:29782 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbZH0U1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 16:27:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAASIlkpR92Cn/2dsb2JhbADYbAmEEAU
Date: Thu, 27 Aug 2009 22:27:09 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Chris Friesen <cfriesen@nortel.com>, linuxppc-dev@ozlabs.org,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix book E watchdog to take WDIOC_SETTIMEOUT arg in
	seconds
Message-ID: <20090827202709.GK29382@infomag.iguana.be>
References: <4A8303C6.7070705@nortel.com> <20090827111458.GB29382@infomag.iguana.be> <20090827120841.GA25303@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827120841.GA25303@zod.rchland.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

> >Now we only need someone that can look at the CONFIG_4xx cases still :-)
> 
> It seems the FSL watchdog is much more flexible than the one found in 4xx
> cores.  On 4xx, you basically have 4 static choices that represent specific
> times determined by the clock frequency.  I'm concerned that the lack of
> granularity here will result in less than desirable behavior.
> 
> For example, with a 400MHz clock you would get choices of roughly:
> 
> 5.2 ms
> 83.9 ms
> 1.34 s
> 21.47 s
> 
> Personally, I consider the first two options basically unusable.  Considering
> the second two, if a user were to say "Set the timeout for 2 seconds" they
> would then get a timeout of 21 seconds with the framework Chris' patch has
> set up.  That doesn't really seem to be ideal to me.

Hmm, my opinion: in that case we should use a timer that triggers the watchdog until userspaces times out (like we do for other watchdogs allready). Maybe we should split this driver. I have the same issue with the Freescale i.mx driver that is under review also.

Kind regards,
Wim.


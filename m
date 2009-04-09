Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbZDIEX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbZDIEX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbZDIEXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:23:11 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:51478 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbZDIEXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:23:09 -0400
X-IronPort-AV: E=Sophos;i="4.40,158,1238990400"; 
   d="scan'208";a="86026906"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: IRQF_SAMPLE_RANDOM question...
Date: Thu, 9 Apr 2009 00:24:42 -0400
User-Agent: KMail/1.9.5
CC: "Gilles Espinasse" <g.esp@free.fr>,
       "Chris Peterson" <cpeterso@cpeterso.com>,
       "Matt Mackall" <mpm@selenic.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200904061430.26276.rgetz@blackfin.uclinux.org> <2c6601c9b894$756e4000$f9b5a8c0@pii350> <49DD3036.4020107@nortel.com>
In-Reply-To: <49DD3036.4020107@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200904090024.42951.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 09 Apr 2009 04:22:26.0563 (UTC) FILETIME=[C9D19530:01C9B8CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 8 Apr 2009 19:16, Chris Friesen pondered:
> Gilles Espinasse wrote:
> 
> > Readme say :
> > "This daemon attempts to collect real randomness from fluctuations of
> > high-frequency clocks on a PC's mainboard. The basic assumption is that
> > mainboard and CPU are clocked by two separate physical clocks."
> 
> > How large is this basic assumption true, on x86, on other arch?
> 
> Isn't the cpu frequency normally a phase-locked multiple of the 
> mainboard bus frequency?

Yes - typically they are the same.

However - I have tested clrngd out on a Blackfin, and found it gave an 
excessively high load - but it did give ok results. 77% of the time (659/848 
times) it provided results that passed it's built in FIPS test. It did die a 
few times (if the FIPS tests fails 5 times in a row clrngd aborts).

I was going to write my own (based on a similar architecture) - but use the 
RTC clock and the main clock - since those actually would be different 
physical crystals - and the accuracy of low cost 32kHz crystals is crappy  
(typically measureable with a high enough core clock).

But I think delays of cache misses/flushes will dominate things anyway - which 
is why clrngd works today on systems which are using the same clock source. 
(but since it will be RTC interrupt driven, vs while(1){} like clrngd - the 
load will be much lower).

-Robin

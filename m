Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZCTIhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZCTIhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZCTIh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:37:26 -0400
Received: from mga12.intel.com ([143.182.124.36]:62683 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754036AbZCTIhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:37:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,394,1233561600"; 
   d="scan'208";a="122327823"
Message-ID: <49C355CF.1040409@linux.intel.com>
Date: Fri, 20 Mar 2009 09:37:35 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Subject: Re: [patch] x86, bts: use atomic memory allocation
References: <20090318192700.A6038@sedona.ch.intel.com> <20090319161141.GA12144@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E923FFCA4@irsmsx504.ger.corp.intel.com>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E923FFCA4@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> When I boot that configuration (without the additional patches), I get some
> error dumps on the screen including a call trace. Unfortunately, the interesting
> part scrolls out of the top of my screen and the boot stops.

Standard ways to handle that:
- boot with vga=0x0f07 to get smaller fonts (if it doesn't work use vga=ask and select suitable number)
- use a serial console, possibly with earlyprintk
- use firescope if the system has a ieee1394 connection. That can access the log buffer. You
need a 1394 cable, but those are easy to get. See Documentation/debugging-via-ohci1394.txt

For this particular case it might be enough to move the selftest to run much later
and then use netconsole or similar after it has been set up.

-Andi

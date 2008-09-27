Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYI0TYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYI0TYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 15:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYI0TYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 15:24:07 -0400
Received: from mga07.intel.com ([143.182.124.22]:24449 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753569AbYI0TYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 15:24:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,322,1220252400"; 
   d="scan'208";a="52244772"
Message-ID: <48DE8851.9070900@linux.intel.com>
Date: Sat, 27 Sep 2008 12:24:01 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, jbarnes@virtuousgeek.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ioremap sanity check to catch mapping requests exceeding
 the BAR sizes
References: <20080926014334.GF15609@linux-os.sc.intel.com>	<48DDDDDE.7060707@goop.org>	<20080927122145.49ad0cf4@lxorguk.ukuu.org.uk>	<48DE46AB.8070505@goop.org> <20080927172546.6220ccbb@lxorguk.ukuu.org.uk>
In-Reply-To: <20080927172546.6220ccbb@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sat, 27 Sep 2008 07:43:55 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
>> Alan Cox wrote:
>>>> Any attempt to use ioremap on memory is a bug, so you should warn about
>>>> that too.
>>>>     
>>> We use it to ioremap things like the BIOS...
>> Yeah, that's fine.  I mean using ioremap on system memory is a bug.
> 
> On system memory mapped by the kernel which I assume is what you mean -
> the BIOS is often shadowed system memory and we have platforms where
> memory pages not mapped into or managed the OS are ioremap() targets.
> 
> That however is getting pedantic - I just didn't want anyone to overdo
> the sanity checks

the existing sanity check checks to see if the kernel thinks if the memory is usable
for its own use, eg it uses the e820 table, the same one we use for feeding all memory
into the page allocator.

reserved and other similar types is not what ioremap complains about

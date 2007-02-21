Return-Path: <linux-kernel-owner+w=401wt.eu-S1161312AbXBUP6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161312AbXBUP6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161316AbXBUP6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:58:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:32000 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161312AbXBUP6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:58:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,202,1170662400"; 
   d="scan'208"; a="185205291:sNHT3442966989"
Message-ID: <45DC6C2C.7040509@intel.com>
Date: Wed, 21 Feb 2007 07:58:36 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Linux 2.6.21-rc1
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <1172064762.25076.56.camel@localhost.localdomain>
In-Reply-To: <1172064762.25076.56.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Feb 2007 15:58:37.0489 (UTC) FILETIME=[25D99210:01C755D1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 2007-02-20 at 20:53 -0800, Linus Torvalds wrote:
>> But there's a ton of architecture updates (arm, mips, powerpc, x86, you 
>> name it), ACPI updates, and lots of driver work. And just a lot of 
>> cleanups.
>>
>> Have fun,
> 
> Yup. Fun starts in drivers/net/e1000
> 
> e1000 is not working anymore. ifup fails permanentely.
>  ADDRCONF(NETDEV_UP): eth0: link is not ready
> nothing else
> 
> bisect identifies:
> 
> d2ed16356ff4fb9de23fbc5e5d582ce580390106 is first bad commit
 > commit d2ed16356ff4fb9de23fbc5e5d582ce580390106

I think we need to drop this now. The report that says that this *fixes* 
something might have been on regular interrupts only. I currently suspect that 
it breaks all MSI interrupts, which would make sense if I look a the code. Very 
bad indeed.

I'll try to come up with something else or send a patch that reverts it.

Auke


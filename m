Return-Path: <linux-kernel-owner+w=401wt.eu-S965966AbXCFRMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965966AbXCFRMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965309AbXCFRMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:12:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:31504 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965966AbXCFRMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:12:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,254,1170662400"; 
   d="scan'208"; a="191050859:sNHT1358156093"
Message-ID: <45EDA04A.1060500@intel.com>
Date: Tue, 06 Mar 2007 09:09:30 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
References: <20070225175559.GC12392@stusta.de>  <20070227100202.GV3822@kernel.dk> <20070227102109.GG6745@elf.ucw.cz>  <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu>  <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk>  <20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz>  <20070305084257.GA4464@mellanox.co.il>  <20070305101120.GA23032@elte.hu> <1173198401.24738.340.camel@localhost.localdomain> <Pine.LNX.4.64.0703060845480.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703060845480.5963@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2007 17:09:31.0080 (UTC) FILETIME=[348ECC80:01C76012]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 6 Mar 2007, Thomas Gleixner wrote:
>> SATA has another nice feature. Somehow there is an interrupt pending on
>> the SATA controller, which comes in somewhere in the middle of resume.
>> If it happens before the SATA code resumed, the SATA code ignores the
>> interrupt and the interrupt is disabled due to "nobody cared", which in
>> turn prevents SATA to ever become functional again. >

> And if you don't want to do any of these things (or are unable to, because 
> of some ordering constraint or bad design), then you simply need to 
> unregister and re-register the interrupt handler over sleep.
> 
>> Any idea on that one ?
> 
> Jeff, Auke, does this ring any bells?

For the e1000 issue, the problem is solved with Eric Biederman's 3-patch msi 
cleanups. You should have another message in your mailbox confirming that I 
tested his patches and the MSI warning for e1000 suspend-resume is gone with them.

Cheers,

Auke

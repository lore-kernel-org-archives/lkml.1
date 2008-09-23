Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbYIWBTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbYIWBTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYIWBTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:19:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:27170 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbYIWBTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:19:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,449,1217833200"; 
   d="scan'208";a="383252484"
Date: Mon, 22 Sep 2008 18:19:08 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Message-ID: <20080923011908.GC25045@linux-os.sc.intel.com>
References: <20080919123320.GF7222@lenovo> <20080922090405.GA12630@elte.hu> <86802c440809220301l662824aasa9cf3a437f42bd9@mail.gmail.com> <20080922100532.GD24705@elte.hu> <20080922103736.GA22024@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922103736.GA22024@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 03:37:36AM -0700, Cyrill Gorcunov wrote:
> [Ingo Molnar - Mon, Sep 22, 2008 at 12:05:32PM +0200]
> |
> | * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> |
> | > On Mon, Sep 22, 2008 at 2:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
> | >
> | > BTW
> | >
> | > x2apic and IRmapping make io_apic.c and apic.c ugly.
> |
> | yes. Any ideas how to clean it up some more?
> |
> | the kmalloc looks quite ugly, especially with this kfree() teardown
> | sequence we have now.
> |
> |       Ingo
> |
> 
> yes Ingo - it's ugly but I had not that many choises:
> 
> 1) allocate/deallocate if failed inside same routine
> 2) deallocate in restore_IO_APIC_setup (which would be much more
>    ugly and obscure)
> 3) allocate and deallocate in completely separated routines - didn't
>    even tried :)
> 
> So I've stopped on (1) 'case it was less_changing_the_sources patch.

I think Yinghai is complaing about other code aswell (HAVE_X2APIC etc).
Probably I should move some of the x2apic/interrupt-remapping code
setup out of io_apic.c and apic.c to a common file.

thanks,
suresh

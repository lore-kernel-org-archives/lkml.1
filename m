Return-Path: <linux-kernel-owner+w=401wt.eu-S932779AbZHGPJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779AbZHGPJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932718AbZHGPJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:09:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:39605 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594AbZHGPJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:09:37 -0400
Subject: Re: [RT] Lockdep warning on boot with 2.6.31-rc5-rt1.1
From: Peter Zijlstra <peterz@infradead.org>
To: Clark Williams <williams@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       "greg@kroah.com" <greg@kroah.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20090807094608.4b0efea1@torg>
References: <20090807094608.4b0efea1@torg>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Aug 2009 17:09:03 +0200
Message-Id: <1249657743.32113.733.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 09:46 -0500, Clark Williams wrote:
> Peter,
> 
> I'm getting this warning from lockdep when booting on my T60. 
> 
> The two addresses reported (0xffffffff812664a2 and 0xffffffff812664ae)
> actually bracket one call to mutex_lock() in driver_attach() so I'm not
> sure what the complaint is.
> 
> Clark
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.31-rc5-rt1.1 #37
> ---------------------------------------------
> swapper/1 is trying to acquire lock:
>  (&dev->mutex){+.+...}, at: [<ffffffff812664ae>]
> __driver_attach+0x48/0x81
> 
> but task is already holding lock:
>  (&dev->mutex){+.+...}, at: [<ffffffff812664a2>]
> __driver_attach+0x3c/0x81
> 
> other info that might help us debug this:
> 1 lock held by swapper/1:
>  #0:  (&dev->mutex){+.+...}, at: [<ffffffff812664a2>]
> __driver_attach+0x3c/0x81

Oh, that's tglx who's gone wild with sem->mutex conversions.

It used to be that _all_ dev->sem instances were taken on suspend or
something like that, I think that got fixed a long while back.

I'd have to look at what the current locking requirements for dev->sem
are. 

I remember talking to Alan on several occasions about this, and I just
went over some of the old emails, but I must say the precise
requirements stay hidden from me. Also, I'm not sure these emails are
still representative of the current state.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXCSUUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXCSUUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbXCSUUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:20:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:12358 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbXCSUUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:20:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,302,1170662400"; 
   d="scan'208"; a="212254878:sNHT12577960808"
From: Jesse Barnes <jesse.barnes@intel.com>
To: David Miller <davem@davemloft.net>
Subject: Re: BSOD
Date: Mon, 19 Mar 2007 13:20:20 -0700
User-Agent: KMail/1.9.6
Cc: zaitcev@redhat.com, jg@laptop.org, linux-kernel@vger.kernel.org
References: <20070319120807.af36ef5d.zaitcev@redhat.com> <200703191254.36373.jesse.barnes@intel.com> <20070319.130544.115907938.davem@davemloft.net>
In-Reply-To: <20070319.130544.115907938.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703191320.20217.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 19, 2007 1:05 pm David Miller wrote:
> From: Jesse Barnes <jesse.barnes@intel.com>
> Date: Mon, 19 Mar 2007 12:54:36 -0700
>
> > Kernel based modesetting should get us a lot of things:
>
> But for panics you're ignoring what Peter and I are saying.
>
> Mode setting is complex and it is not going to work exactly when you
> need the kernel crash message the most.
>
> After debugging the kernel for 10+ years I can tell you one thing,
> for a bad crash what's going to happen is you'll get the printk but
> that's about all that will work at that point, and the kernel is
> going to hang next.  Sometimes you won't get the whole panic message,
> just the beginning, even with the most simplistic printk
> implementation.
>
> You will not, I repeat, will not be able to mode switch or anything
> non-trivial like that when the kernel is in this state.
>
> Mode switching on panic, just say no. :-)

You must have missed this part:

"As for what happens at panic time, if the kernel knows how to modeset 
we can do whatever we want:  conservatively clear an appropriate 
scanout buffer and render our panic there, switch into a better mode to 
dump the panic if we think that's possible, or just hang without any 
output like we do today."

Where "an appropriate" might mean "currently active" which would give us 
what you and Peter are saying.  The point is, with the modesetting code 
in the kernel, we'll actually *have* all the information you outlined 
in your previous mail so we'll have a chance to dtrt when the panic 
occurs (which is to tell the user about it).

So don't worry, I'm not ignoring that point at all, doing much of 
anything after panic/oops is a crapshoot. :)

Jesse

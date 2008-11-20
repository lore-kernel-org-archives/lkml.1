Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbYKTPFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbYKTPFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758608AbYKTPCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:02:22 -0500
Received: from smtp.nokia.com ([192.100.122.230]:41917 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758990AbYKTPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:02:21 -0500
Date: Thu, 20 Nov 2008 17:01:48 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Richard Purdie <rpurdie@linux.intel.com>
Cc: felipe.balbi@nokia.com, me@felipebalbi.com, linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       Greg KH <greg@kroah.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH] led: simplify led_trigger_register_simple
Message-ID: <20081120150148.GL7476@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1226545753-6640-1-git-send-email-me@felipebalbi.com> <1226579912.5402.21.camel@dax.rpnet.com> <20081113181407.GC17166@frodo> <20081113191046.GA25855@frodo> <1227188008.22263.9.camel@ted> <20081120141438.GK7476@gandalf.research.nokia.com> <1227192359.22263.23.camel@ted>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227192359.22263.23.camel@ted>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 20 Nov 2008 15:02:03.0570 (UTC) FILETIME=[F2772120:01C94B20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 02:45:59PM +0000, ext Richard Purdie wrote:
> On Thu, 2008-11-20 at 16:14 +0200, Felipe Balbi wrote:
> > > In answer to your question about kfree, I agree it needs to be called
> > > upon error. The callers should just be calling
> > > led_trigger_unregister_simple() in their failure paths though which
> > > should take care of all problems? I know we used to register the simple
> > > triggers late in paths so no error handling was needed to keep the code
> > > simple and minimise the LED triggers impact on those systems.
> > 
> > Well, led_trigger_register_simple() doesn't return anything. Imagine
> > led_trigger_register_simple() fails, but the driver author decides
> > it's not a failure if, let's say, a led doesn't turn on when we insert
> > a mmc card to the slot since it doesn't change functionality.
> > 
> > Now, imagine the user notes the led is not turning on and decides to
> > unload and reload the module to try again. Once again the led doesn't go
> > on. If the user keeps trying, it's quite a dangerous memory leak, right
> > ?
> 
> So we have the module loading and one of two things happens:
> 
> led_trigger_register_simple() succeeds
> led_trigger_register_simple() fails (probably from kmalloc failure)
> 
> The module doesn't know or care which happened. When the module unloads
> it calls led_trigger_unregister_simple() which will free the memory in
> the success case and do nothing in the case where it had failed.
> 
> So there is no memory leak?

Hmmm, you are right. Didin't think about the exit path. But freeing in
led_triger_register_simple() if led_trigger_register() fails, also
doesn't seem wrong.

-- 
balbi

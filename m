Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbZDPB6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbZDPB6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZDPB6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:58:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:44354 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZDPB6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:58:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W8hEHs7WLu2GtK6IWhI69JBmL1MVZFLNsa3WXbQmnYpdRAw/PHudsIRjku+ax2BhsD
         L/QjHo4XsIB4n1zkw+Dhg0ZbEeEtsEAhYBckLFKkmZsvCj6dGbkJV/pdqwhErn00NEem
         zL9vmMu/Uyz6PDKRQHH5HXm7L7gifu7MISu9o=
Date: Wed, 15 Apr 2009 18:58:27 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: tglx@linutronix.de, David Brownell <david-b@pacbell.net>,
       hskinnemoen@atmel.com, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, imre.deak@nokia.com, mingo@elte.hu,
       Bill Gatliff <bgat@billgatliff.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH] ads7846: fix unsafe disable_irq (was [REGRESSION]
	threaded interrupt handler support breaks (some) irq handling on
	AVR32)
Message-ID: <20090416015826.GA2413@dtor-d630.eng.vmware.com>
References: <1239685153.19815.12.camel@linux-51e8.site> <1239698225.29831.14.camel@linux-51e8.site> <1239759053.29831.37.camel@linux-51e8.site> <20090415095710.5c853a7f@hskinnemoen-d830> <1239842517.29831.47.camel@linux-51e8.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239842517.29831.47.camel@linux-51e8.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 10:41:57AM +1000, Ben Nizette wrote:
> On Wed, 2009-04-15 at 09:57 +0200, Haavard Skinnemoen wrote:
> > Shouldn't that be disable_irq_nosync()?
> 
> Indeed, good catch.  That fixes it.
> 
> --------------8<--------------------
> 
> The use of disable_irq inside the handler for the interrupt being
> disabled has always been dangerous.  disable_irq should wait for that
> handler to complete before returning -> deadlock.
> 
> For some reason this wasn't actually the case until 3aa551c9b was merged
> but since this time, the ads7846 driver has deadlocked the system on
> first interrupt.
> 
> Convert the driver to use the handler-safe _nosync variant.
> 

Applied, thank you very much Ben.

-- 
Dmitry

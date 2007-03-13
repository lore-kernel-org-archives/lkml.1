Return-Path: <linux-kernel-owner+w=401wt.eu-S965758AbXCMNzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965758AbXCMNzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 09:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965757AbXCMNzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 09:55:44 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:2229 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965753AbXCMNzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 09:55:43 -0400
Message-ID: <45F6AD5D.4020700@rtr.ca>
Date: Tue, 13 Mar 2007 09:55:41 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jim Radford <radford@blackbean.org>
Cc: Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net,
       Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial regression fix
References: <45F57F63.7010308@rtr.ca> <45F584D9.4090802@rtr.ca> <200703121948.21453.oneukum@suse.de> <45F5B67E.7000105@rtr.ca> <20070312203331.GA6769@kroah.com> <20070312224235.GB3709@blackbean.org> <20070312225922.GA4064@blackbean.org> <20070313001819.GA6147@kroah.com> <20070313004142.GA4835@blackbean.org> <45F60482.6010501@rtr.ca> <20070313091408.GA7205@blackbean.org>
In-Reply-To: <20070313091408.GA7205@blackbean.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Radford wrote:
> On Mon, Mar 12, 2007 at 09:55:14PM -0400, Mark Lord wrote:
>
>> So where does the memory get freed -- the structure pointed at
>> by the serial->port[i] thingie ?  It's not a leak, is it?
> 
> It gets free'd through device_unregister
> 
>     for (i = 0; i < num_ports; ++i) {
>        ...
>        port->dev.release = &port_release;
>        ...
>        retval = device_register(&port->dev);
> 
> which means that until all the drivers get converted to use
> ->port_probe() and ->port_remove() (which gets called by
> device_unregister) and stop using the ->port[] array in ->shutdown()
> we need to have ->shutdown() called before device_unregister.
> 
>>>>> Look at changeset d9a7ecacac5f8274d2afce09aadcf37bdb42b93a in Linus's
>>>>> tree from Jim Radford:
> 
>>>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d9a7ecacac5f8274d2afce09aadcf37bdb42b93a
> 
> So, this patch should be reverted for now.

Okay, so.. Jim, could you spell it out for us now?

I'm confused.

Based on the current 2.6.21-rc3-git*,
tell us *exactly* what (if any) needs to be reverted,
and *exactly* which (if any) of my suggested patches to apply ?

Thanks

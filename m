Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXJNS1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXJNS1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbXJNS1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:27:05 -0400
Received: from 1wt.eu ([62.212.114.60]:3107 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbXJNS1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:27:04 -0400
Date: Sun, 14 Oct 2007 20:25:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Message-ID: <20071014182542.GA2832@1wt.eu>
References: <1192383445.8372.18.camel@dell1.softservecom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192383445.8372.18.camel@dell1.softservecom.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vitaliy,

On Sun, Oct 14, 2007 at 08:37:25PM +0300, Vitaliy Ivanov wrote:
> Hello Willy, Greg and list,
> 
> I have ported adutux driver for ADU series device list from 2.6 to 2.4. 
> More on devices:
> http://www.ontrak.net/products.htm#Table%205
> 
> Once I needed to make ADU200 work under 2.4 enterprise kernel and wasn't able to do this.
> My organization decided to use another device for our private purposes.
> 
> I was always interested in kernel hacking and thought it's a good point to start it from.
> Just to add I'm not related to Ontrak in anyway. Also I'm not a Google person.
> Did it just for fun.
> 
> A few technical notes:
> - I was trying to leave as much as possible adutux driver code from 2.6 as it's in the 2.6 mainline for a long time and seems like it works OK there.
> - Used one shot interrupt urbs that's why all intervals are 0.
> - Reused 67 minor number from 2.6 kernel for this device.
> - All 2.4 related changes are taken/reused from usb-skeleton.
> 
> Patch is based on the latest 2.4.35.3.
> 
> Performed a lot of tests but only under UHCI controller and ADU200 and all seems to be OK.
> 
> I would like someone to perform code review as it's my first attempt to the kernel programming. 
> Any comments, propositions are welcome.

At first glance, your backport looks clean. I have one comment however,
about the author and version. Since it's a backport from an existing
driver and not one you wrote yourself (eventhough you did the backporting
work), the MODULE_AUTHOR should not be changed (but I think you can add
yourself to it after a comma). The version should reflect the version you
derived it from, at least for bug tracking purposes.

Also, while I understand you would be very glad to get your work merged
(we all once had our first piece of code), I'd like to mention that you
seem to be the only user of this hardware under 2.4 (since it is currently
not supported). I'm not sure it's very reasonable to merge a driver in 2.4
right now for just one user. Even more, I understand that you finally moved
to other hardware, so my feeling is that you did this work as an exercice
(which was cleanly performed, BTW), but that it will not get any real use
in 2.4.

Since 2.4 is moving very slowly, there should be no problem applying
this patch to any version if you really need to use it. Maybe it would
even work with your 2.4 enterprise kernel.

Note that I'm not radically opposed to merge support for new drivers.
If you provide us with really good arguments for a merge, maybe I'll
change my opinion, but I doubt about it, since the only users of this
device must currently be running 2.6.

Thanks,
Willy


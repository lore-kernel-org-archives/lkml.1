Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXFKTZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXFKTZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbXFKTYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:24:43 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45553 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007AbXFKTYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:24:42 -0400
Message-ID: <466DA173.70205@us.ibm.com>
Date: Mon, 11 Jun 2007 14:24:35 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       xen-devel <xen-devel@lists.xensource.com>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: More virtio users
References: <466BA965.6050208@qumranet.com>	<1181463220.16428.24.camel@localhost.localdomain> <466D04C2.8010403@redhat.com>
In-Reply-To: <466D04C2.8010403@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
>   Hi,
> 
>> Framebuffer is an interesting one.  Virtio doesn't assume shared memory,
>> so naively the fb you would just send outbufs describing changed memory.
>> This would work, but describing rectangles is better.  A helper might be
>> the right approach here
> 
> Rectangles work just fine for a framebuffer console.  They stop working 
> once you plan to run any graphical stuff such as an X-Server on top of 
> the framebuffer.  Only way to get notified about changes is page faults, 
> i.e. 4k granularity on the linear framebuffer memory.
> 
> Related to Framebuffer is virtual keyboard and virtual mouse (or better 
> touchscreen), which probably works perfectly fine with virtio.  I'd 
> guess you can even reuse the input layer event struct for the virtio 
> events.

Virtio seems like overkill for either of those things.  It's necessary 
for pure PV but not at all necessary for something like KVM.

> Xen has virtual framebuffer, kbd & mouse, although not (yet?) in the 
> paravirt_ops patch queue, so there is something you can look at ;)

In retrospect, IMHO, a shared framebuffer was a bad idea for Xen.  It's 
easy enough for dealing with an unaccelerated display, but once you 
start getting into more advanced features like blitting (which is really 
important actually for decent VNC performance), the synchronization 
becomes a big problem.

If we were to do a PV display driver again, I really think something 
that is closer to a VNC protocol is the right way to go.  There simply 
isn't a significant performance overhead to copying the relatively small 
amount of memory.

So virtio in it's current form would actually be pretty useful for that.

Regards,

Anthony Liguori


> cheers,
>   Gerd


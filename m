Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbXC3U3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbXC3U3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 16:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbXC3U3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 16:29:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:40625 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbXC3U3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 16:29:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c+oCajTZ8nTT+5tTp887froLAFtawOD6OCrUG3gLL8FK91N7XHCxyfyxx7h1yEEIdb36RxCOJB5c31c2QaVOLuubxr+AyO0ejBWDYGicqvfsclRn60I4lrLnKGa9QGSYxPT6ioKxv+cPeL2+aLe33YZcUM9j83Abe8gxugY5M9k=
Message-ID: <d120d5000703301329o67d8720dp1f7875a9ff4e11dd@mail.gmail.com>
Date: Fri, 30 Mar 2007 16:29:37 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: usb hid: reset NumLock
Cc: "Jiri Kosina" <jkosina@suse.cz>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuart_hayes@dell.com
In-Reply-To: <20070330125437.b3229471.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
	 <d120d5000703301114r420a9604i34b6a015e6bad285@mail.gmail.com>
	 <20070330125437.b3229471.zaitcev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
> On Fri, 30 Mar 2007 14:14:20 -0400, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
>
> > > I didn't like a) layering violation, and b) that they defeat filtering
> > > unconditionally. Why have any filtering then?
> > >
> > > Instead, I propose for USB HID driver to reset NumLock on probe. Like this:
> > >
> > > --- a/drivers/usb/input/hid-core.c
>
> > This is fine and that's what we do in atkbd probe but maybe we should
> > move that in input core and reset leds as part of
> > input_register_device()?
>
> Sure, as long as it works. I think (as much as I understand), that we
> already attempt to do this indirectly. input_register_device invokes
> ->start handlers, and the kbd_start attempts to reset LEDs, but fails
> because of the state filtering.
>

Not exactly... Keyboard handler's start method tries to bring state of
new keyboard in sync with the state of the rest of keyboards. The
purpose of start() is not to complete hardware initialization but to
adjust logical state of the device according to handler's
requirements...

But I am backpedaling on my statement about moving it into input core.
The driver (HID in this case) should properly reset the device before
registering it with input layer.

-- 
Dmitry

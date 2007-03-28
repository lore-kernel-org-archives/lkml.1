Return-Path: <linux-kernel-owner+w=401wt.eu-S1751033AbXC1NYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033AbXC1NYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbXC1NYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:24:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:31548 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbXC1NYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k/L+WrnSXX7MnZqE2buGJ7lhK70c5hKiwDD+0pykKW7Bfe8nl6P6nk3AMeSBjx6ofWrVQi6ZzYSTmWzp5a+vPDknz6qNuk4YEyZdwRlHuJv33Oro5eK2ECb+2c1/EV209OWHr/+aa49uRPmxHXXz8KYAOAcwiVCzvPNRMHDy8GA=
Message-ID: <d120d5000703280624q62c26ffbs80e31d557bf3c72b@mail.gmail.com>
Date: Wed, 28 Mar 2007 09:24:06 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: appletouch quirk doesn't run at resume
Cc: "Thomas Meyer" <thomas@m3y3r.de>, "Jiri Kosina" <jkosina@suse.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@stusta.de>, "Soeren Sonnenburg" <kernel@nn7.de>,
       linux-input@atrey.karlin.mff.cuni.cz,
       "Peter Osterlund" <petero2@telia.com>
In-Reply-To: <Pine.LNX.4.64.0703281414410.29565@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <1174078066.13341.279.camel@localhost.localdomain>
	 <1174087552.13341.332.camel@localhost.localdomain>
	 <45FBBDEA.9060708@m3y3r.de> <20070318004240.GO752@stusta.de>
	 <Pine.LNX.4.64.0703181934530.4195@jikos.suse.cz>
	 <45FD8CA3.10405@m3y3r.de>
	 <Pine.LNX.4.64.0703182020070.4195@jikos.suse.cz>
	 <4609866C.4060602@m3y3r.de>
	 <Pine.LNX.4.64.0703281414410.29565@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/07, Jiri Kosina <jikos@jikos.cz> wrote:
> On Tue, 27 Mar 2007, Thomas Meyer wrote:
>
> > It seems, that after the resume all usb devices gets removed and plug in
> > again (virtually!). This results in a new input device name:
>
> Yes, this is what actually happens. JFYI see current thread on lkml which
> is a bit realted - http://lkml.org/lkml/2007/3/27/149 if interested.
>
> > This change confuses the X synaptics driver:
> > Touchpad no synaptics event device found (checked 11 nodes)
> > Touchpad The /dev/input/event* device nodes seem to be missing
> > (EE) xf86OpenSerial: Cannot open device /dev/input/event2
> >         No such file or directory.
> > (WW) Touchpad: cannot open input device
> > One could say that the synaptics driver rightly complains about the
> > missing event2 device! So is this a bug in the X synaptics driver?
>
> You can of course work this around by adding an udev rule such as
>
> SUBSYSTEM=="input",KERNEL=="event*",SYSFS{name}=="appletouch",SYMLINK+="input/appletouchpad"
>
> and the let Xorg use /dev/input/appletouchpad, which will always be a
> symlink to the correct device.
>

I am not sure if this would help... According to the excerpt from X
log synaptics driver attempted to scan evdev devices and locate the
touchpad. However if this scan happen before udev had a chance to
process the event and create new /dev/input/eventX device node it will
fail.

I wonder if we should adjust the X driver to spin for a couple of
seconds in EventAutoDevProbe if the touchpad was already seen once...
Peter?

-- 
Dmitry

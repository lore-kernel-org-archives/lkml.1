Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbXE3PSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbXE3PSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXE3PSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:18:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:19588 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbXE3PSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JpBrr7cN5O0C5UlZc5IRvBr5dypEeIcm4rwUIdb4GCFgad+YtSa9HC7IjoK0bDqoPdG3LbK7oBHt9tdYqWx2n2vwjGWjHWap0goKKVAxRMO9Ou8j00AXdXldRa3wtYV3A6zB5pPVMESZWxlUPz7Mk4TMGw0+D8hG89lvM+X5kmw=
Message-ID: <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com>
Date: Wed, 30 May 2007 16:18:36 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: linux-kernel@vger.kernel.org, "Dmitry Torokhov" <dtor@insightbb.com>
In-Reply-To: <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <200705210016.20794.dtor@insightbb.com>
	 <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
	 <d9b9d95f0705291657o47ef42d3jea2a1dae3e31bbdb@mail.gmail.com>
	 <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz>
	 <d9b9d95f0705300214u7eb257fg783aefd73077d33@mail.gmail.com>
	 <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/07, Jiri Kosina <jkosina@suse.cz> wrote:
> do any data appear in the kernel log when you generate events with the
> device (i.e. move the joystick, press the buttons, etc)? That should be
> reported if DEBUG_DATA is defined properly on the older kernels.

Not at all... only my own debug messages from joydev (like:
recalibrating for value 2048) when a new limit is reached. I've even
changed "printk(KERN_DEBUG ...)" to a plain printk() as I do on joydev
to avoid fall into the wrong log level but didn't work as well.

I've changed USB DEBUG in menuconfig, saved the new conf.

The files I've changed manually (undef -> define) were:
 -> drivers/hid/
hid-core.c:#undef DEBUG
hid-core.c:#undef DEBUG_DATA
hid-input.c:#undef DEBUG

-> drivers/usb/input/
hid-core.c:#undef DEBUG
hid-core.c:#undef DEBUG_DATA
hid-ff.c:#undef DEBUG
hid-tmff.c:#undef DEBUG

than
$ make drivers/hid/hid.ko drivers/usb/input/usbhid.ko
$ rmmod usbhid hid ; modprobe usbhid hid

the output from the last mail was on both /var/log/messages and
syslog, although syslog had other messages from the network card
(using ndiswrapper).

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm

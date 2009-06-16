Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZFPMrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZFPMrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZFPMrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:47:08 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:44832 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZFPMrH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:47:07 -0400
MIME-Version: 1.0
In-Reply-To: <20090616090435.GA21321@pengutronix.de>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de> 
	<1244765062-14144-3-git-send-email-w.sang@pengutronix.de> 
	<fa686aa40906140740m43e9dd8am4d242310f681c95c@mail.gmail.com> 
	<20090616090435.GA21321@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 16 Jun 2009 06:46:47 -0600
Message-ID: <fa686aa40906160546q73765b66h204334e3ca081de0@mail.gmail.com>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@ozlabs.org,
       "Hans J. Koch" <hjk@linutronix.de>, Magnus Damm <magnus.damm@gmail.com>,
       linuxppc-dev@ozlabs.org, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 3:04 AM, Wolfram Sang<w.sang@pengutronix.de> wrote:
>
>> > diff --git a/Documentation/powerpc/dts-bindings/uio-generic.txt b/Documentation/powerpc/dts-bindings/uio-generic.txt
>> > new file mode 100644
>> > index 0000000..8ad9861
>> > --- /dev/null
>> > +++ b/Documentation/powerpc/dts-bindings/uio-generic.txt
>> > @@ -0,0 +1,16 @@
>> > +UIO for custom devices
>> > +
>> > +A device which will be mapped using the UIO subsystem.
>> > +
>> > +Properties:
>> > + - compatible : should contain the specific model used, followed by
>> > +                "generic-uio".
>> > + - reg : address range(s) of the device (up to MAX_UIO_MAPS)
>> > + - interrupts : interrupt of the device
>> > +
>> > +Example:
>> > +        c64fpga@0 {
>> > +                compatible = "ptx,c64fpga001", "generic-uio";
>> > +                reg = <0x0 0x10000>;
>> > +                interrupts = <0 0 3>;
>> > +        };
>>
>> Hmmm, I'm not happy about this.  The device tree describes the
>> hardware, not the way Linux uses the hardware.  UIO definitely falls
>> into the category of Linux implementation detail.
>
> Yes, I am aware of that. I just started with the mechanisms which are available
> today and hoped we could find some compatible-value which will suit all needs.

Trouble is a value that suits all needs today probably won't a year
from now.  :-)

>> This should be approached from the other way around.  Either the
>> generic-uio of_platform driver should contain an explicit list of
>> devices to be handled by UIO,
>
> Well, that could lead to a quite huge match_table over time.
>
>> or the OF infrastructure should be modified to allow things like force
>> binding of_devices to of_drivers at runtime.
>
> That is an interesting idea. I could imagine something like a 'new_compatible"
> entry in the sysfs-section of the driver similar to 'new_id' for PCI. After
> writing a new compatible-string into it, matching will triggered again with the
> new entry added. That could (should?) also be placed at the of-core-level. Or
> did you have something else in mind?

Yeah, that sounds appropriate.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

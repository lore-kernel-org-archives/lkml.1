Return-Path: <linux-kernel-owner+w=401wt.eu-S1760279AbXEXAHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279AbXEXAHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbXEXAHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:07:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:46662 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbXEXAHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:07:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NV9B/FTYAu+2jBNzHHSO1HCXZU0eMtMa9cIGdSDCOZxaB8nKOpJt3yYW+3WRE+E438iSBHK+4OGA2JuNT/XzuLE5YChS2zVsrH2cPQJ7aG+niNncUTPpetL9WiRZ58u3B/0pcyEjG4cJOaO07YJHxnDEoR60ezem8j9r5bc/iIk=
Message-ID: <4654D743.10907@gmail.com>
Date: Thu, 24 May 2007 04:07:31 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIE
References: <46543045.3030904@gmail.com> <20070523155958.GA5282@kroah.com>	<4654AB40.6060208@gmail.com> <adaejl79rh0.fsf@cisco.com>	<4654BC10.2000808@gmail.com> <adazm3v89hv.fsf@cisco.com>	<4654C85B.6060505@gmail.com> <adatzu385g1.fsf@cisco.com>
In-Reply-To: <adatzu385g1.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > It looks so, from the logs. The only problem is i can't disable the
>  > interrupts, if i write "0" to 0x500, the interrupt/enable register, it
>  > gives me a solid freeze. If i read from the handler, commenting out the
>  > disable interrupts in init, that read also gives me a solid freeze. This
>  > lead me to think that there could be some problem with the MMIO block
>  > access.
> 
> OK, this looks reasonable:
> 
>  > #define saa716x_write(dat, addr)	writel((dat), (saa716x->mmio)+(addr))
> 
> although
> 
>   a) your driver has no hope of working on a system with more than one
>      device of this type; and

to make it working with more than one device shouldn't be hard once it
is going on.

>   b) there's really no point in obfuscating a simple use of writel()
>      this way.
> 
> Why does the device come up in a state where it generates a stream of
> interrupts as soon as you enable the PCI device?  That's somewhat
> unusual behavior, although certainly not unheard of.

Will ask the vendor, what's going on.

> This really has the feel of a typical driver bug to me, not anything
> related to general PCIe access.  I've definitely wedged my system many
> times while trying to poke a device the right way.

Yeah, you seem to sound right.

> Also, where are you getting the offset of 0x500 from?  

The register offset is according to the device specs. Of course i
already found some wrong offsets etc, maybe this one's wrong too, probably.

> Is it possible
> that the offset is really being given to you in bits (so you should
> use 0x500 / 8) or 32-bit words (so you should use an offset of 0x500 *

It says, the base address is currently 500h

> 4)?  Are the datasheet / programming docs available for this device?

Working with this device, under NDA with the vendor.

> I actually have:
> 
>   02:00.0 Multimedia controller: Philips Semiconductors Unknown device 7162
> 
> in one of my systems so I'd be somewhat interested in getting a driver
> working too.

Cool, won't be that long, just the bridge part remains, most other parts
are done or do exist.

Thanks,
Manu


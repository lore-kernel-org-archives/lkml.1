Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0CBNqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:46:16 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:63416 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab0CBNqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:46:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=mtzzck8AXWypo1AjOGdLdnJB/yqmEMAtvMSrrBp2445oObXPHpgw1EOo2NohpIEPmi
         nqYTS2PRjGJuwuhNYhnz02POC7MTcfkDLToHmDgRVCD6PmKK61d98gS1v+6ox+0f+DIU
         YHte9HyTUDNIRW8xbmMwYYVclANdWjld2fKA8=
MIME-Version: 1.0
In-Reply-To: <20100302065224.GL3389@atomide.com>
References: <41322.192.168.10.89.1267454612.squirrel@dbdmail.itg.ti.com>
	 <20100301184600.GC3389@atomide.com>
	 <E0D41E29EB0DAC4E9F3FF173962E9E94026ED95FC1@dbde02.ent.ti.com>
	 <20100302060821.GI3389@atomide.com>
	 <E0D41E29EB0DAC4E9F3FF173962E9E94026ED9600D@dbde02.ent.ti.com>
	 <20100302065224.GL3389@atomide.com>
Date: Tue, 2 Mar 2010 19:16:12 +0530
X-Google-Sender-Auth: 8f938fee5fabaa06
Message-ID: <618f0c911003020546mb7c8412o2bac4e86a081332b@mail.gmail.com>
Subject: Re: [PATCH] serial: Add OMAP high-speed UART driver.
From: Venkatraman S <svenkatr@ti.com>
To: Tony Lindgren <tony@atomide.com>, "G, Manjunath Kondaiah" <manjugk@ti.com>,
       "Raja, Govindraj" <govindraj.raja@ti.com>, Greg KH <greg@kroah.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 12:22 PM, Tony Lindgren <tony@atomide.com> wrote:
> * G, Manjunath Kondaiah <manjugk@ti.com> [100301 22:24]:
>>
>>
>>
>> > > > > +     up->uart_dma.prev_rx_dma_pos =
>> > up->uart_dma.rx_buf_dma_phys;
>> > > > > +     if (cpu_is_omap44xx())
>> > > > > +             omap_writel(0, OMAP44XX_DMA4_BASE
>> > > > > +                     +
>> > OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
>> > > > > +     else
>> > > > > +             omap_writel(0, OMAP34XX_DMA4_BASE
>> > > > > +                     +
>> > OMAP_DMA4_CDAC(up->uart_dma.rx_dma_channel));
>> > > >
>> > > > NAK. Please don't use omap_read/write for for new code. And do not
>> > > > tinker with the omap hardware registers directly in the driver.
>> > > >
>> > > > This needs to be done properly in
>> > arch/arm/plat-omap/dma.c instead.
>> > >
>> > > Thanks for the suggestion.
>> > >
>> > > Currently, dma_read/dma_write are #define's in dma.c which
>> > cannot be
>> > > accessed outside dma.c. I don't see any API's in dma.c for
>> > setting required
>> > > value for this register?
>> >
>> > Hmm isn't this the same as omap_get_dma_dst_pos(int lch)? If you're
>> > trying do something that's not in dma.c, we can add a new function
>> > for it.
>>
>> The omap_get_dma_dst_pos(int lch) is for read operation in CDAC register.
>> But, We need to write required value into CDAC register. For this, I propose:
>>
>> omap_set_dma_dst_pos(int lch, int value) which does not exist in current dma
>> driver.
>
> OK, it that's needed.
>
> Tony
> --
CDAC is a shadow register used for monitoring the DMA channel.
 I think it would be a lot
simpler if omap_start_dma() always resets CDAC to 0, and the UART driver
just not set it explicitly.

Simple wrapper APIs doing get / set on individual DMA registers is as
difficult to understand
as omap_read / omap_write, IMHO.

Best regards,
Venkat.

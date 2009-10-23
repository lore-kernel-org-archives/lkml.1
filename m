Return-Path: <linux-kernel-owner+w=401wt.eu-S1751246AbZJWMWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbZJWMWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 08:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZJWMWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 08:22:15 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49433 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZJWMWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 08:22:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ki2JjeOzVCpn/AjJ10w5EwkgBnFCtOyX9JDjhgqX+nbEbu6XxXLQ6tat6T1bz3KjP3
         QzhxcQE3/hKiGim2o6OAgaFr88n+ejWn8HK6vDasfYk7VjbIcvSEPD3Odqel54q27QkD
         ZbAUrn6a5yr+OMY2Hp0fNJ7eEFnGwdtA/gHKs=
MIME-Version: 1.0
In-Reply-To: <20091013205657.GD12700@atomide.com>
References: <65168.192.168.10.89.1253788033.squirrel@dbdmail.itg.ti.com>
	 <20091007215116.GB29320@atomide.com>
	 <d6a0f7aa0910072314h77383e31r2330725b614ba472@mail.gmail.com>
	 <E0D41E29EB0DAC4E9F3FF173962E9E940253C6C560@dbde02.ent.ti.com>
	 <20091009174635.GH25892@atomide.com>
	 <7f9d1ffb0910122354o64b5aa01l3fe33ab78dfb5f23@mail.gmail.com>
	 <20091013205657.GD12700@atomide.com>
Date: Fri, 23 Oct 2009 17:52:18 +0530
Message-ID: <d6a0f7aa0910230522y7cf8ec13w498378bf1fa9e5d6@mail.gmail.com>
Subject: Re: [PATCHv1 1/3] OMAP UART: Adds omap-serial driver support.
From: Govindraj <govindraj.ti@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: kishore kadiyala <kishorek.kadiyala@gmail.com>,
       "G, Manjunath Kondaiah" <manjugk@ti.com>,
       "Raja, Govindraj" <govindraj.raja@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 2:26 AM, Tony Lindgren <tony@atomide.com> wrote:
> * kishore kadiyala <kishorek.kadiyala@gmail.com> [091012 23:54]:
>> Tony,
>>
>> On Fri, Oct 9, 2009 at 11:16 PM, Tony Lindgren <tony@atomide.com> wrote:
>> > * G, Manjunath Kondaiah <manjugk@ti.com> [091008 00:41]:
>> >>
>> >> Govind,
>> >> > -----Original Message-----
>> >> > From: linux-omap-owner@vger.kernel.org
>> >> > [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Govindraj
>> >> > Sent: Thursday, October 08, 2009 11:44 AM
>> >> > To: Tony Lindgren
>> >> > Cc: Raja, Govindraj; linux-omap@vger.kernel.org;
>> >> > linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org
>> >> > Subject: Re: [PATCHv1 1/3] OMAP UART: Adds omap-serial driver support.
>> >> >
>> >> > On Thu, Oct 8, 2009 at 3:21 AM, Tony Lindgren
>> >> > <tony@atomide.com> wrote:
>> >> > > * Govindraj.R <govindraj.raja@ti.com> [090924 03:29]:
>> >> > >> From: Govindraj R <govindraj.raja@ti.com>
>> >> > >>
>> >> > >> This patch adds support for OMAP3430-HIGH SPEED UART Controller.
>> >> > >>
>> >> > >> Signed-off-by:        Govindraj R <govindraj.raja@ti.com>
>> >> > >> Reviewed-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
>> >> > >> Reviewed-by: Tony Lindgren <tony@atomide.com>
>> >> > >
>> >> > > You should only add Reviewed-by if Alan or me have replied with it.
>> >> > >
>> >> > > So far I've only replied with some comments that have not yet
>> >> > > been fixed, so we're few more steps from being Reviewd-by.
>> >> > >
>> >> > > <snip>
>> >> > >
>> >> > >> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
>> >> > >> index 6553833..67a7129 100644
>> >> > >> --- a/drivers/serial/Kconfig
>> >> > >> +++ b/drivers/serial/Kconfig
>> >> > >> @@ -1359,6 +1359,53 @@ config SERIAL_OF_PLATFORM
>> >> > >>         Currently, only 8250 compatible ports are supported, but
>> >> > >>         others can easily be added.
>> >> > >>
>> >> > >> +config SERIAL_OMAP
>> >> > >> +     bool "OMAP serial port support"
>> >> > >> +     depends on ARM && ARCH_OMAP
>> >> > >> +     select SERIAL_CORE
>> >> > >> +     help
>> >> > >> +     If you have a machine based on an Texas Instruments
>> >> > OMAP CPU you
>> >> > >> +     can enable its onboard serial ports by enabling this option.
>> >> > >> +
>> >> > >> +config SERIAL_OMAP_CONSOLE
>> >> > >> +     bool "Console on OMAP serial port"
>> >> > >> +     depends on SERIAL_OMAP
>> >> > >> +     select SERIAL_CORE_CONSOLE
>> >> > >> +     help
>> >> > >> +     If you have enabled the serial port on the Texas
>> >> > Instruments OMAP
>> >> > >> +     CPU you can make it the console by answering Y to
>> >> > this option.
>> >> > >> +
>> >> > >> +     Even if you say Y here, the currently visible virtual console
>> >> > >> +     (/dev/tty0) will still be used as the system console
>> >> > by default, but
>> >> > >> +     you can alter that using a kernel command line option such as
>> >> > >> +     "console=ttyS0". (Try "man bootparam" or see the
>> >> > documentation of
>> >> > >> +     your boot loader (lilo or loadlin) about how to pass
>> >> > options to the
>> >> > >> +     kernel at boot time.)
>> >> > >> +
>> >> > >> +config SERIAL_OMAP_DMA_UART1
>> >> > >> +     bool "UART1 DMA support"
>> >> > >> +     depends on SERIAL_OMAP
>> >> > >> +     help
>> >> > >> +     If you have enabled the serial port on the Texas
>> >> > Instruments OMAP
>> >> > >> +     CPU you can enable the DMA transfer on UART 1 by answering
>> >> > >> +     to this option.
>> >> > >> +
>> >> > >> +config SERIAL_OMAP_DMA_UART2
>> >> > >> +     bool "UART2 DMA support"
>> >> > >> +     depends on SERIAL_OMAP
>> >> > >> +     help
>> >> > >> +     If you have enabled the serial port on the Texas
>> >> > Instruments OMAP
>> >> > >> +     CPU you can enable the DMA transfer on UART 2 by answering
>> >> > >> +     to this option.
>> >> > >> +
>> >> > >> +config SERIAL_OMAP_DMA_UART3
>> >> > >> +     bool "UART3 DMA support"
>> >> > >> +     depends on SERIAL_OMAP
>> >> > >> +     help
>> >> > >> +     If you have enabled the serial port on the Texas
>> >> > Instruments OMAP
>> >> > >> +     CPU you can enable the DMA transfer on UART 3 by answering
>> >> > >> +     to this option.
>> >> > >> +
>> >> > >>  config SERIAL_OF_PLATFORM_NWPSERIAL
>> >> > >>       tristate "NWP serial port driver"
>> >> > >>       depends on PPC_OF && PPC_DCR
>> >> > >
>> >> > > There's absolutely no need for having Kconfig options for the DMA
>> >> > > support. Please pass that in platform_data from the board-*.c files.
>> >> > >
>> >> > > This is the third time I'm commenting on the same issue!
>> >> > >
>> >> > > What's the point of posting these patches for review if the issues
>> >> > > don't get solved?
>> >> >
>> >> >
>> >> > The omap-serial uart driver is designed to work either in interrupt
>> >> > mode or in DMA mode,
>> >> > We have provided this option so that one can select interrupt mode or
>> >> > DMA mode based on the uart usage, if somebody is using uart as console
>> >> > then interrupt mode will do, else if used with bluetooth which does
>> >> > huge data transfer then DMA mode can be selected.
>> >> >
>> >> > Don't you think this should be a configurable option using kconfig
>> >> > rather than passing as platform data?
>> >
>> > Nope. I think it should be platform_data and should be possible to override
>> > vith a kernel cmdline option. That's because we support compiling in and
>> > booting many boards the same kernel binary.
>> >
>> >> > if used as platform data then one has to modify platform data to
>> >> > switch between the interrupt and DMA mode.
>> >
>> > How about set some kernel cmdline options if you want to override the
>> > default settings?
>>
>>    Using cmdline options, will make specific UART switch  dynamically
>>    between Non-DMA and DMA mode which is not handled in the driver.
>
> Switching between dma transfers and pio should be easy to do, we're
> already doing that in various omap drivers like mmc, musb/tusb
> and onenand.

I am planning to remove kconfig options, and add static mode values in platform
data for uart port dma mode usage for an given uart port.

Any given uart port can be configured to work in DMA or non dma
mode based on the board configuration, and decision has to be made by
developer itself (based on performance etc..) and should not rely on user.

What do you say?


> So I would recommend making that change, it is quite trivial
> to do and will make the code much cleaner. And also gets rid
> of the issue with Kconfig settings breaking booting for other
> boards.
>
>>    how abt using bootargs to share this Mode info ?
>
> The bootargs should override what is passed from platform_data.

Providing bootarg option is easy, I'll add support if insisted.

IMHO static setting in platform data will do.

---
Regards,
Govindraj.R



> Regards,
>
> Tony
>
>>
>> >
>> >> Usage of UART is board dependent. It's usage will not change dynamically for
>> >> a given board. This can be removed from Kconfig and move it to respective
>> >> board file-> board-*.c
>> >
>> > Or can be changed from kernel cmdline if necessary.
>> >
>> > Regards,
>> >
>> > Tony
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>

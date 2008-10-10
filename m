Return-Path: <linux-kernel-owner+w=401wt.eu-S1761600AbYJJPsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600AbYJJPsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760107AbYJJPse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:48:34 -0400
Received: from sperry-02.control.lth.se ([130.235.83.189]:43278 "EHLO
	sperry-02.control.lth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759766AbYJJPsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:48:33 -0400
Message-ID: <48EF7949.4010108@control.lth.se>
Date: Fri, 10 Oct 2008 17:48:25 +0200
From: Anders Blomdell <anders.blomdell@control.lth.se>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make ATNGW100 serial ports configurable
References: <48EF6762.2080205@control.lth.se> <20081010165814.1c62eabf@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081010165814.1c62eabf@hskinnemo-gx745.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:
> Anders Blomdell <anders.blomdell@control.lth.se> wrote:
>> Make configuration of ATNGW100 serial ports selectable in kernel configuration.
>>
>> Signed-off-by: Anders Blomdell <anders.blomdell@control.lth.se>
> 
> Gak. If we're going down this path, why not add #ifdefs for every other
> conceivable hardware mod as well and turn the ATNGW100 board code into
> an even worse mess than the ATSTK1000 board code?
OK, good point. The reason I sent in the patch is that people on AVRFreaks had
asked how to do it, and putting it in the configuration would (theoretically)
make it possible to catch pin conflicts.


> The ATNGW100 has one serial port on board, so IMO the standard board
> code should only initialize that one port.
Which was my intention, unless SERIAL_ATMEL_USARTn was selected.

> However, it might be sensible to add some sort of interface for
> expansion board code. For example something like this:
> 
> #ifdef CONFIG_ATNGW100_EXPANSION
> 	atngw100_setup_expansion_board();
> #endif
Since that file has to reside inside the kernel tree (?), one could almost as
easily replace the entire setup.c.

Shouldn't this be something like:

void __init setup_board(void)
{
...
#ifdef CONFIG_ATNGW100_EXPANSION
 	atngw100_setup_expansion_board();
#endif
}

static int __init atngw100_init(void)
{
...
#ifdef CONFIG_ATNGW100_EXPANSION
 	atngw100_init_expansion_board();
#endif
}

> This will allow people with hardware mods to add all the extra devices
> they need, including serial ports, by simply adding another file with
> expansion board code. People who aren't afraid to solder stuff on their
> boards shouldn't be afraid of writing some board code too, right?
> 
> What do you think?
An even nicer way of handling it (provided that initialization does not need to
take place during boot), might be to do EXPORT_SYMBOL() on
at32_add_device_usart, at32_map_usart, etc and then write a loadable module that
handles the initialization.

Regards

Anders Blomdell


-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden

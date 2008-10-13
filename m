Return-Path: <linux-kernel-owner+w=401wt.eu-S1761466AbYJMNES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbYJMNES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbYJMNEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:04:07 -0400
Received: from sperry-02.control.lth.se ([130.235.83.189]:60194 "EHLO
	sperry-02.control.lth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbYJMNEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:04:06 -0400
Message-ID: <48F3473E.6070305@control.lth.se>
Date: Mon, 13 Oct 2008 15:03:58 +0200
From: Anders Blomdell <anders.blomdell@control.lth.se>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make ATNGW100 serial ports configurable
References: <48EF6762.2080205@control.lth.se>	<20081010165814.1c62eabf@hskinnemo-gx745.norway.atmel.com>	<48EF7949.4010108@control.lth.se>	<20081013122727.7298bd4a@hskinnemo-gx745.norway.atmel.com>	<48F32899.5000006@control.lth.se> <20081013143447.5e0519b3@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081013143447.5e0519b3@hskinnemo-gx745.norway.atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen wrote:
> Anders Blomdell <anders.blomdell@control.lth.se> wrote:
>> Haavard Skinnemoen wrote:
>>> Well, you could do it like that, but you could also just add another
>>> postcore_initcall. The only hook which is really needed is the "setup"
>>> part, and only if you have additional serial ports.
>> Does that mean that 'at32_add_device_usart(...);' is not needed?
> 
> It's needed, but you don't need a hook in the main board code to do it.
> You can simply do
> 
> static int __init my_expansion_board_init(void)
> {
> 	at32_add_device_usart(...);
> 	/* more stuff */
> }
> postcore_initcall(my_expansion_board_init);
> 
>>>> An even nicer way of handling it (provided that initialization does not need to
>>>> take place during boot), might be to do EXPORT_SYMBOL() on
>>>> at32_add_device_usart, at32_map_usart, etc and then write a loadable module that
>>>> handles the initialization.
>>> Hmm...why would that be nicer exactly?
>> You could compile your board specific inits outside the kernel tree, making it
>> much easier to follow kernel versions (not everyone gets their board specific
>> code into the kernel tree :-).
> 
> Adding EXPORT_SYMBOLs purely for use by out-of-tree modules is
> generally frowned upon. 
If I'm not mistaken, you need EXPORT_SYMBOL for any loadable module, be it in-
or out-of-tree.

>And patching in an additional file to the build is just about the easiest
>thing you can do.
Next to config options and loadable modules out-of-tree :-)


>>> What _I_ think would be a nicer way to do it is to implement support
>>> for flattened device trees and get rid of the board code entirely. Or
>>> almost entirely; it depends on how complete we can make the device tree.
>> I don't understand the above paragraph, could you please elaborate?
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/powerpc/booting-without-of.txt;h=de4063cb4fdc0ad6abea29d766cae78616837311;hb=HEAD
OK, essentially compile all drivers into the kernel and let the boot-loader tell
us what to activate. Gives a small kernel bloat (which I can live with), but
what if two conflicting drivers (e.g. same I/O pin) are selected by the
flattened tree?

But I take your replies that you are adamantly against kernel options for the
atngw100, so I'll drop the subject for now (letting everyone figure out their
favorite way to configure modified boards).

Regards

Anders

-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden

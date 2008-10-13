Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbYJMMfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbYJMMfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 08:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbYJMMfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 08:35:38 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:42493 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbYJMMfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 08:35:37 -0400
Date: Mon, 13 Oct 2008 14:34:47 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make ATNGW100 serial ports configurable
Message-ID: <20081013143447.5e0519b3@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <48F32899.5000006@control.lth.se>
References: <48EF6762.2080205@control.lth.se>
	<20081010165814.1c62eabf@hskinnemo-gx745.norway.atmel.com>
	<48EF7949.4010108@control.lth.se>
	<20081013122727.7298bd4a@hskinnemo-gx745.norway.atmel.com>
	<48F32899.5000006@control.lth.se>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Oct 2008 12:34:30.0924 (UTC) FILETIME=[0A2E0CC0:01C92D30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Blomdell <anders.blomdell@control.lth.se> wrote:
> Haavard Skinnemoen wrote:
> > Well, you could do it like that, but you could also just add another
> > postcore_initcall. The only hook which is really needed is the "setup"
> > part, and only if you have additional serial ports.
> Does that mean that 'at32_add_device_usart(...);' is not needed?

It's needed, but you don't need a hook in the main board code to do it.
You can simply do

static int __init my_expansion_board_init(void)
{
	at32_add_device_usart(...);
	/* more stuff */
}
postcore_initcall(my_expansion_board_init);

> >> An even nicer way of handling it (provided that initialization does not need to
> >> take place during boot), might be to do EXPORT_SYMBOL() on
> >> at32_add_device_usart, at32_map_usart, etc and then write a loadable module that
> >> handles the initialization.
> > 
> > Hmm...why would that be nicer exactly?
> You could compile your board specific inits outside the kernel tree, making it
> much easier to follow kernel versions (not everyone gets their board specific
> code into the kernel tree :-).

Adding EXPORT_SYMBOLs purely for use by out-of-tree modules is
generally frowned upon. And patching in an additional file to the build
is just about the easiest thing you can do.

> > What _I_ think would be a nicer way to do it is to implement support
> > for flattened device trees and get rid of the board code entirely. Or
> > almost entirely; it depends on how complete we can make the device tree.
> I don't understand the above paragraph, could you please elaborate?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/powerpc/booting-without-of.txt;h=de4063cb4fdc0ad6abea29d766cae78616837311;hb=HEAD

Haavard

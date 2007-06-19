Return-Path: <linux-kernel-owner+w=401wt.eu-S1764818AbXFSS7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764818AbXFSS7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764107AbXFSS7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:59:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:20819 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764228AbXFSS7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hqrJxbIZGHu7yIPelqjUcGkoBS25Ccq+wp/546x+zvDAp7IYjWqUIfRLv21H1Gu6TwOzUlczW8BocXE3Qh/JDfNxim5A+QIbIvS2+nRMarCSfynh4xVLIQ0qn2aem9pjyVWExrbCMUWGiCZ0VzxcQGeRr0PJSYvF9c5nQ6MFdKY=
Message-ID: <d120d5000706191159w29ebd0dajbd6cb9ac78d4faa2@mail.gmail.com>
Date: Tue, 19 Jun 2007 14:59:34 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: Writing a driver for a legacy serial device
Cc: LKML <linux-kernel@vger.kernel.org>, "Vojtech Pavlik" <vojtech@ucw.cz>
In-Reply-To: <20070619190502.05d4e0c8@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070619190502.05d4e0c8@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On 6/19/07, Jean Delvare <khali@linux-fr.org> wrote:
> Hi all,
>
> I want to write a Linux kernel driver for a device which connects to
> the legacy serial port. I started writing a driver, however I am
> already stuck at the very beginning. The .connect function of my serial
> driver is never called, and I just don't get why. I couldn't find any
> documentation about writing such a legacy driver in Documentation nor
> in LDD3. Is there anyone out there which could lend a helping hand?
>
> I know that the device and my serial port both work. I can talk to the
> device using minicom just fine. I have the following drivers loaded:
>
> $ lsmod | grep 8250
> 8250_pnp               11648  0
> 8250                   23464  1 8250_pnp
> serial_core            19392  1 8250
>
> Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
> 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>
> But I need to implement my driver in kernel space. My code looks like
> this:
>
> static struct serio_device_id taos_serio_ids[] = {
>        {
>                .type   = SERIO_RS232,
>                .proto  = SERIO_ANY,
>                .id     = SERIO_ANY,
>                .extra  = SERIO_ANY,
>        },
>        { 0 }
> };
> MODULE_DEVICE_TABLE(serio, taos_serio_ids);
>
> static struct serio_driver taos_drv = {
>        .driver         = {
>                .name   = "taos-evm",
>        },
>        .description    = "TAOS evaluation module driver",
>        .id_table       = taos_serio_ids,
>        .connect        = taos_connect,
>        .disconnect     = taos_disconnect,
>        .interrupt      = taos_interrupt,
> };
>
> static int __init taos_init(void)
> {
>        return serio_register_driver(&taos_drv);
> }
>
> static void __exit taos_exit(void)
> {
>        serio_unregister_driver(&taos_drv);
> }
>
> The problem is that taos_connect is never called. I suppose that I need
> different values for .type, .proto or .id, except that I just don't
> know what to put there. I tried a few random values without success.
> What's the trick?
>

You need to load serport modue and play with inputattach utility.

-- 
Dmitry

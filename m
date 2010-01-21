Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395Ab0AUBbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab0AUBbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 20:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433Ab0AUBbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 20:31:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab0AUBbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 20:31:31 -0500
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Bastien Nocera <hadess@hadess.net>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
In-Reply-To: <4B57A2D4.9030204@gmail.com>
References: <1264011793.1735.3683.camel@localhost.localdomain>
	 <4B57A2D4.9030204@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 21 Jan 2010 01:31:25 +0000
Message-ID: <1264037485.1735.4988.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 18:41 -0600, Robert Hancock wrote:
> On 01/20/2010 12:23 PM, Bastien Nocera wrote:
> > As those computers never had any i8042 controllers, and the
> > current lookup code could potentially lock up/hang/wait for
> > timeout for long periods of time.
> >
> > Fixes intermittent hangs on boot on a MacbookAir1,1
> >
> > Signed-off-by: Bastien Nocera<hadess@hadess.net>
> 
> I assume this is happening because of this code in 
> drivers/input/serio/i8042-x86ia64io.h:
> 
>          if (!i8042_pnp_kbd_devices && !i8042_pnp_aux_devices) {
>                  i8042_pnp_exit();
> #if defined(__ia64__)
>                  return -ENODEV;
> #else
>                  printk(KERN_INFO "PNP: No PS/2 controller found. 
> Probing ports directly.\n");
>                  return 0;
> #endif

Actually, the error message is "i8042.c: No controller found". Which
happens very early in a sub-function of i8042_init().

So I don't think this would solve the problem.

> In other words, on x86, if PNP and/or ACPI don't indicate any PS/2 
> controller exists, we randomly bang on the ports in the expectation 
> they'll be there anyway. This seems rather misguided. It would seem like 
> a better idea to fix this rather than adding yet another DMI list 
> (especially since there likely are, or will be, machines without i8042 
> other than Macs).

They might also have a better BIOS than the Macs and avoid hanging when
that happens...

> I can see continuing on and probing if PNP isn't present on the machine, 
> but certainly if ACPI is enabled, I don't think we should be doing such 
> things.


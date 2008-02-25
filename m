Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbYBYTP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbYBYTP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYBYTPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:15:49 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56154 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbYBYTPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:15:49 -0500
Date: Mon, 25 Feb 2008 20:16:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc] pcmcia section mismatches
Message-ID: <20080225191601.GB23161@uranus.ravnborg.org>
References: <200802251145.13015.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802251145.13015.arvidjaar@mail.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:45:12AM +0300, Andrey Borzenkov wrote:
> During compilation:
> 
>   LD [M]  drivers/pcmcia/pcmcia_core.o
> WARNING: drivers/pcmcia/pcmcia_core.o(.data+0x1d4): Section mismatch in reference from the variable pccard_sysfs_interface to the function .devinit.text:pccard_sysfs_add_socket()
> The variable pccard_sysfs_interface references
> the function __devinit pccard_sysfs_add_socket()
> If the reference is valid then annotate the
> variable with __init* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> WARNING: drivers/pcmcia/pcmcia_core.o(.data+0x1d8): Section mismatch in reference from the variable pccard_sysfs_interface to the function .devexit.text:pccard_sysfs_remove_socket()
> The variable pccard_sysfs_interface references
> the function __devexit pccard_sysfs_remove_socket()
> If the reference is valid then annotate the
> variable with __exit* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
>   LD [M]  drivers/pcmcia/pcmcia.o
> WARNING: drivers/pcmcia/pcmcia.o(.data+0x4c): Section mismatch in reference from the variable pcmcia_bus_interface to the function .devinit.text:pcmcia_bus_add_socket()
> The variable pcmcia_bus_interface references
> the function __devinit pcmcia_bus_add_socket()
> If the reference is valid then annotate the
> variable with __init* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> and later during modpost:
> 
>   MODPOST 260 modules
> WARNING: drivers/pcmcia/pcmcia.o(.data+0x4c): Section mismatch in reference from the variable pcmcia_bus_interface to the function .devinit.text:pcmcia_bus_add_socket()
> The variable pcmcia_bus_interface references
> the function __devinit pcmcia_bus_add_socket()
> If the reference is valid then annotate the
> variable with __init* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> WARNING: drivers/pcmcia/pcmcia_core.o(.data+0x1d4): Section mismatch in reference from the variable pccard_sysfs_interface to the function .devinit.text:pccard_sysfs_add_socket()
> The variable pccard_sysfs_interface references
> the function __devinit pccard_sysfs_add_socket()
> If the reference is valid then annotate the
> variable with __init* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> WARNING: drivers/pcmcia/pcmcia_core.o(.data+0x1d8): Section mismatch in reference from the variable pccard_sysfs_interface to the function .devexit.text:pccard_sysfs_remove_socket()
> The variable pccard_sysfs_interface references
> the function __devexit pccard_sysfs_remove_socket()
> If the reference is valid then annotate the
> variable with __exit* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> WARNING: drivers/pcmcia/rsrc_nonstatic.o(.data+0x9c): Section mismatch in reference from the variable pccard_rsrc_interface to the function .devinit.text:pccard_sysfs_add_rsrc()
> The variable pccard_rsrc_interface references
> the function __devinit pccard_sysfs_add_rsrc()
> If the reference is valid then annotate the
> variable with __init* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> WARNING: drivers/pcmcia/rsrc_nonstatic.o(.data+0xa0): Section mismatch in reference from the variable pccard_rsrc_interface to the function .devexit.text:pccard_sysfs_remove_rsrc()
> The variable pccard_rsrc_interface references
> the function __devexit pccard_sysfs_remove_rsrc()
> If the reference is valid then annotate the
> variable with __exit* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> config attached.

Hi Andrey.

I tried your config with my tree patched with all patches I have submitted
for section mismatch warnings and the good news is that there were no warnings.
The patches are queued up mostly in -mm and some will likely only
hit mainline in next merge window. So be paitient a few more months.

	Sam

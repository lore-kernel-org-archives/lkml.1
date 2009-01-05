Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZAEMrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZAEMrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZAEMrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:47:05 -0500
Received: from h155.mvista.com ([63.81.120.155]:56625 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750877AbZAEMrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:47:02 -0500
Message-ID: <4962013F.9090900@ru.mvista.com>
Date: Mon, 05 Jan 2009 15:46:55 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Shane McDonald <mcdonald.shane@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] Resurrect IT8172 IDE controller driver
References: <E1LIkqz-00021S-O5@localhost>
In-Reply-To: <E1LIkqz-00021S-O5@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Shane McDonald wrote:

> Support for the IT8172 IDE controller was removed from the kernel
> sometime after 2.6.18.  Support for the only boards that used the IT8172
> was removed from the kernel after 2.6.18, as they had never compiled
> since 2.6.0.  However, there are a couple of platforms that use this
> chip: the PMC-Sierra Xiao Hu thin-client computer, which is no longer
> in production, and the Linksys NSS4000 Network Attached Storage box,
> which is based on the Xiao Hu board.  I am attempting to add support
> for the Xiao Hu to the kernel, and this IT8172 IDE controller is the
> first bit of code in this effort.
>
> This patch resurrects the IT8172 IDE controller code.  I began with
> the 2.6.18 version of the it8172.c file, and have moved it forward so
> that it works with the latest version of the kernel.  I have run this
> driver on a PMC-Sierra Xiao Hu board with the 2.6.28 kernel, and
> I have had no problems with it in my configuration.  The attached patch
> applies cleanly against 2.6.28.
>
> Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>   
[...]
> diff -uprN a/drivers/ide/it8172.c b/drivers/ide/it8172.c
> --- a/drivers/ide/it8172.c	1969-12-31 18:00:00.000000000 -0600
> +++ b/drivers/ide/it8172.c	2008-12-31 17:49:41.000000000 -0600
> @@ -0,0 +1,166 @@
> +/*
> + *
> + * BRIEF MODULE DESCRIPTION
> + *      IT8172 IDE controller support
> + *
> + * Copyright (C) 2000 MontaVista Software Inc.
> + * Copyright (C) 2008 Shane McDonald
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
> + *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
> + *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
> + *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
> + *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
> + *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
> + *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
> + *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
> + *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
> + *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
> + *  You should have received a copy of the  GNU General Public License along
> + *  with this program; if not, write  to the Free Software Foundation, Inc.,
> + *  675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/ioport.h>
> +#include <linux/pci.h>
> +#include <linux/ide.h>
> +#include <linux/init.h>
> +
> +#define DRV_NAME "IT8172"
> +
> +static void it8172_set_pio_mode(ide_drive_t *drive, const u8 pio)
> +{
> +	ide_hwif_t *hwif	= HWIF(drive);
> +	struct pci_dev *dev	= to_pci_dev(hwif->dev);
> +	u16 drive_enables;
> +	u32 drive_timing;
> +
> +	/*
> +	 * The highest value of DIOR/DIOW pulse width and recovery time
> +	 * that can be set in the IT8172 is 8 PCI clock cycles.  As a result,
> +	 * it cannot be configured for PIO mode 0.  This table sets these
> +	 * parameters to the maximum supported by the IT8172.
> +	 */
> +	static const u8 timings[] = { 0x3f, 0x3c, 0x1b, 0x12, 0x0a };
>   

   The octal literals would fit this case better (3-bit field == octal 
digit). Oh well... :-)

MBR, Sergei



Return-Path: <linux-kernel-owner+w=401wt.eu-S1765958AbXFGPxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765958AbXFGPxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765580AbXFGPxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:53:23 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:2438 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932310AbXFGPxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:53:21 -0400
Date: Thu, 7 Jun 2007 17:53:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: i2c@lm-sensors.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>
Subject: Re: [i2c] i2c module aliases
Message-ID: <20070607175342.3006e872@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0706062325270.30244@anakin>
References: <Pine.LNX.4.64.0706062325270.30244@anakin>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Wed, 6 Jun 2007 23:32:38 +0200 (CEST), Geert Uytterhoeven wrote:
> >From browsing through file2alias.c, I have the impression there's a
> missing TO_NATIVE() conversion in the handling of 16-bit (hence,
> endian-affected) i2c IDs.
> This will cause the module aliases to be incorrect when cross-compiling
> for a system with a different endianness.  Is that correct?
> If yes, the patch below adds the missing conversion.
> 
> Of course, no driver seems to use `MODULE_DEVICE_TABLE(i2c, ...)' yet,
> hence nobody noticed.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -390,6 +390,7 @@ static int do_vio_entry(const char *file
>  
>  static int do_i2c_entry(const char *filename, struct i2c_device_id *i2c, char *alias)
>  {
> +	i2c->id = TO_NATIVE(i2c->id);
>  	strcpy(alias, "i2c:");
>  	ADD(alias, "id", 1, i2c->id);
>  	return 1;
> 

Looks correct. However I am curious what this "i2c->id" is supposed to
represent, given that I2C devices do not have any form of ID as PCI or
USB devices have. No driver uses "MODULE_DEVICE_TABLE(i2c, ...)"
probably just because it doesn't make sense. So, rather than fixing
this, shouldn't we simply wipe out struct i2c_device_id? Greg, David?

-- 
Jean Delvare

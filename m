Return-Path: <linux-kernel-owner+w=401wt.eu-S933201AbXK2VVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201AbXK2VVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761029AbXK2VVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:21:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302AbXK2VVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:21:37 -0500
Date: Thu, 29 Nov 2007 13:19:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: drzeus@drzeus.cx, geert@linux-m68k.org, sam@ravnborg.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org
Subject: Re: m68k build failure
Message-Id: <20071129131942.fc7ba88d.akpm@linux-foundation.org>
In-Reply-To: <20071128092856.GV8181@ftp.linux.org.uk>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
	<20071128094856.056c0a3f@poseidon.drzeus.cx>
	<20071128010056.85703a34.akpm@linux-foundation.org>
	<20071128092856.GV8181@ftp.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 09:28:56 +0000
Al Viro <viro@ftp.linux.org.uk> wrote:

> On Wed, Nov 28, 2007 at 01:00:56AM -0800, Andrew Morton wrote:
> > > No the slightest. 12 seems like the correct, padded size. A size of 10 is just weird as the unpadded size is 9 bytes. Could you dump the __mod_sdio_device_table section so we can determine if it is cropped or just oddly padded.
> > > 
> > 
> > err, I'd rather not.  I have no shortage of bugs to be going on with here.
> > 
> > http://userweb.kernel.org/~akpm/cross-compilers/ has the i386->m68k
> > cross-compiler which I use.
> 
> Eh...  m68k has 16bit alignment for unsigned long.  
> 
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -343,7 +343,8 @@ struct sdio_device_id {
>  	__u8	class;			/* Standard interface or SDIO_ANY_ID */
>  	__u16	vendor;			/* Vendor or SDIO_ANY_ID */
>  	__u16	device;			/* Device ID or SDIO_ANY_ID */
> -	kernel_ulong_t driver_data;	/* Data private to the driver */
> +	kernel_ulong_t driver_data	/* Data private to the driver */
> +		__attribute__((aligned(sizeof(kernel_ulong_t))));
>  };
>  
>  /* SSB core, see drivers/ssb/ */

That works, but it's a bit obscure.

sdio_device_id didn't exist in 2.6.23 so we still have time to turn it into
some saner layout.

Who owns this code, anwyay?

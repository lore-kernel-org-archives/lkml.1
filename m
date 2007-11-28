Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbXK1MeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbXK1MeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 07:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbXK1MeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 07:34:10 -0500
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:60148 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbXK1MeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 07:34:09 -0500
Date: Wed, 28 Nov 2007 13:34:02 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Al Viro <viro@ftp.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org
Subject: Re: m68k build failure
In-Reply-To: <20071128132916.125e72ec@poseidon.drzeus.cx>
Message-ID: <Pine.LNX.4.64.0711281332350.29243@anakin>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
 <20071128094856.056c0a3f@poseidon.drzeus.cx> <20071128010056.85703a34.akpm@linux-foundation.org>
 <20071128092856.GV8181@ftp.linux.org.uk> <20071128132916.125e72ec@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Pierre Ossman wrote:
> On Wed, 28 Nov 2007 09:28:56 +0000
> Al Viro <viro@ftp.linux.org.uk> wrote:
> > 
> > Eh...  m68k has 16bit alignment for unsigned long.  
> > 
> > diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> > --- a/include/linux/mod_devicetable.h
> > +++ b/include/linux/mod_devicetable.h
> > @@ -343,7 +343,8 @@ struct sdio_device_id {
> >  	__u8	class;			/* Standard interface or SDIO_ANY_ID */
> >  	__u16	vendor;			/* Vendor or SDIO_ANY_ID */
> >  	__u16	device;			/* Device ID or SDIO_ANY_ID */
> > -	kernel_ulong_t driver_data;	/* Data private to the driver */
> > +	kernel_ulong_t driver_data	/* Data private to the driver */
> > +		__attribute__((aligned(sizeof(kernel_ulong_t))));
> >  };
> >  
> >  /* SSB core, see drivers/ssb/ */
> 
> Unfortunately, that just papers over the symptom and doesn't solve the underlying issue. If you cross-compile on/for an arch with byte alignment, then the issue is back. Or one that uses 4-byte alignment even for u16.
> 
> Is there no directive we can stick in there that forces a reasonable alignment (e.g. alignment == sizeof(type)) independently of arch?

We could use something like is used for compat_*.
E.g. compare compat_s64 in <asm/compat.h> for x86 and powerpc.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

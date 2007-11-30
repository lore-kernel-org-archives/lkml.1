Return-Path: <linux-kernel-owner+w=401wt.eu-S1763193AbXK3Rzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763193AbXK3Rzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760359AbXK3Rz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:55:26 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59599 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758230AbXK3RzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:55:25 -0500
Date: Fri, 30 Nov 2007 18:55:16 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, drzeus@drzeus.cx, geert@linux-m68k.org,
       sam@ravnborg.org, marcel@holtmann.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: m68k build failure
Message-ID: <20071130175516.GN29463@stusta.de>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org> <20071128094856.056c0a3f@poseidon.drzeus.cx> <20071128010056.85703a34.akpm@linux-foundation.org> <20071128092856.GV8181@ftp.linux.org.uk> <20071129131942.fc7ba88d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071129131942.fc7ba88d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 01:19:42PM -0800, Andrew Morton wrote:
> On Wed, 28 Nov 2007 09:28:56 +0000
> Al Viro <viro@ftp.linux.org.uk> wrote:
> 
> > On Wed, Nov 28, 2007 at 01:00:56AM -0800, Andrew Morton wrote:
> > > > No the slightest. 12 seems like the correct, padded size. A size of 10 is just weird as the unpadded size is 9 bytes. Could you dump the __mod_sdio_device_table section so we can determine if it is cropped or just oddly padded.
> > > > 
> > > 
> > > err, I'd rather not.  I have no shortage of bugs to be going on with here.
> > > 
> > > http://userweb.kernel.org/~akpm/cross-compilers/ has the i386->m68k
> > > cross-compiler which I use.
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
> That works, but it's a bit obscure.
> 
> sdio_device_id didn't exist in 2.6.23 so we still have time to turn it into
> some saner layout.
> 
> Who owns this code, anwyay?

Rusty Russell (Cc'ed)


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


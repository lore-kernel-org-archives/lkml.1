Return-Path: <linux-kernel-owner+w=401wt.eu-S1750829AbXBVQSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750829AbXBVQSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbXBVQSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:18:48 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:2868 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbXBVQSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:18:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a13RvhXc0AipBgKZXoA4Q+BVaHcaUPSiUkxNggMTQFOvNo4iPrSHvoNpHzxthm/eelpW9Zvo+EFcet0wr1/ueAfo3c/9YXilNl/yFmZAjvRSTHXJiVQHRU8nJqadE/kB3ZV89Nyjbw3h5YUkTIpm6hF0fMeYmws4fWTX4c0TsR0=
Subject: Re: [Linux-fbdev-devel] [PATCH] nvidiafb: allow ignoring EDID info
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>, Luca Tettamanti <kronos@people.it>,
       linux-fbdev-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <cb7bb73a0702220755y3eb2e5b1r8e7908ae0c1720c9@mail.gmail.com>
References: <ephv35$4i3$1@sea.gmane.org>
	 <20070130203301.GA15067@dreamland.darkstar.lan>
	 <20070204201713.GA12867@dreamland.darkstar.lan>
	 <Pine.LNX.4.64.0702062034380.9224@pentafluge.infradead.org>
	 <cb7bb73a0702061508x767882dcia1b13f85d898b6e7@mail.gmail.com>
	 <1172101406.4217.16.camel@daplas>
	 <cb7bb73a0702220001u6acbdd95ncdc9fad10d06b421@mail.gmail.com>
	 <1172133646.4086.5.camel@daplas>
	 <cb7bb73a0702220548s55380f7fk995726ffd349823b@mail.gmail.com>
	 <1172153358.4306.17.camel@daplas>
	 <cb7bb73a0702220755y3eb2e5b1r8e7908ae0c1720c9@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 00:21:30 +0800
Message-Id: <1172161290.4198.12.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 16:55 +0100, Giuseppe Bilotta wrote:
> On 2/22/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> >
> > Ah, my fault.  Apply this patch on top.
> 
> We're getting closer! The patch now works, and the dmesg has the following info:

Okay.

> 
> 
> ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level,
> low) -> IRQ 11
> nvidiafb: Device ID: 10de0112
> fbmon: The EDID Block of Manufacturer: SHP Model: 0x138e is known to be broken,
> fbmon: trying to fix monitor timings
> nvidiafb: EDID found from BUS2
> ========================================
> Display Information (EDID)
> ========================================
>    EDID Version 1.3
>    Manufacturer: SHP
>    Model: 138e
>    Serial#: 0
>    Year: 1990 Week 0
>    Display Characteristics:
>       Monitor Operating Limits: From EDID
>            H: 30-75KHz V: 60-60Hz DCLK: 170MHz
>       Digital Display Input
>       Sync:
>       Max H-size in cm: 30
>       Max V-size in cm: 23
>       Gamma: 2.20
>       DPMS: Active no, Suspend yes, Standby yes
>       RGB Color Display
>       Chroma
>          RedX:     0.599 RedY:     0.335
>          GreenX:   0.313 GreenY:   0.552
>          BlueX:    0.150 BlueY:    0.145
>          WhiteX:   0.313 WhiteY:   0.328
>       First DETAILED Timing is preferred
>    Detailed Timings
>       160 MHz 1600 1664 1856 2112 1200 1201 1204 1250 -HSync -VSync
> 
>    Supported VESA Modes
>       Manufacturer's mask: 0
>    Standard Timings
>       1600x1200@60Hz
> ========================================
> nvidiafb: CRTC 1 is currently programmed for DFP
> nvidiafb: Using DFP on CRTC 1
> nvidiafb: Panel size is 1600 x 1200
> nvidiafb: Panel is TMDS
> nvidiafb: MTRR set to ON
> nvidiafb: Flat panel dithering disabled
> Console: switching to colour frame buffer device 200x75
> nvidiafb: PCI nVidia NV11 framebuffer (32MB @ 0xE0000000)
> 
> 
> 
> 
> However, I'm still getting the same snowy effects, which doesn't come
> as a surprise since the actual mode timings used are just the same ...
> 

Yes, because the EDID has only 1 mode entry. But now you can use 'fbset
1024x768-60' (or any mode smaller than 1600x1200-60) for example and it
should work.  You might want to change  vfmin and vfmax to 59 and 61
respectively just to get leeway for mode calculation errors. This is in
drivers/video/fbmon.c, particularly b[5] and b[6] in this code:

	case FBMON_FIX_TIMINGS:
		printk("fbmon: trying to fix monitor timings\n");
		b = edid + DETAILED_TIMING_DESCRIPTIONS_START;
		for (i = 0; i < 4; i++) {
			if (!(edid_is_serial_block(b) ||
			      edid_is_ascii_block(b) ||
			      edid_is_monitor_block(b) ||
			      edid_is_timing_block(b))) {
				b[0] = 0x00; 
				b[1] = 0x00;  
				b[2] = 0x00;
				b[3] = 0xfd;   
				b[4] = 0x00;
				b[5] = 60;   /* vfmin */
				b[6] = 60;   /* vfmax */
				b[7] = 30;   /* hfmin */
				b[8] = 75;   /* hfmax */
				b[9] = 17;   /* pixclock - 170 MHz*/
				b[10] = 0;   /* GTF */
				break;
			}

			b += DETAILED_TIMING_DESCRIPTION_SIZE; 
		}

Also try doing fbset 640x480-60, 800x600-60, 1024x768-60 and
1280x1024-60, and if they displayed correctly, we can add these modes to
your EDID block.

Tony


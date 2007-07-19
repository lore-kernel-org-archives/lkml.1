Return-Path: <linux-kernel-owner+w=401wt.eu-S937758AbXGSJCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937758AbXGSJCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761448AbXGSJCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:02:10 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40830 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758087AbXGSJCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:02:08 -0400
Date: Thu, 19 Jul 2007 11:02:07 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [patch 2/3] ps3: BD/DVD/CD-ROM Storage Driver
In-Reply-To: <20070718164351.a92ec032.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.62.0707191100270.8661@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
 <20070716162206.529280000@pademelon.sonytel.be> <20070718164351.a92ec032.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1835406229-1184835727=:8661"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1835406229-1184835727=:8661
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 18 Jul 2007, Andrew Morton wrote:
> > +struct ps3rom_private {
> > +	struct ps3_storage_device *dev;
> > +	struct scsi_cmnd *curr_cmd;
> > +};
> > +#define ps3rom_priv(dev)	((dev)->sbd.core.driver_data)
> > +
> 
> Someone should invent a keyboard which delivers an electric shock when the
> operator types "#define".   In the meanwhile, I get to do the honours.
> 
> Please don't implement in a macro anything which can be implemented in C.

All I needed was a shorthand to access driver_data, for both read and write
access (you cannot do the latter with C, unless you decouple read and write).

> > +			kaddr = kmap_atomic(sgpnt->page, KM_IRQ0);
> > +			if (!kaddr)
> > +				return -1;
> 
> kmap_atomic() cannot fail.  On i386, at least.  If it can fail on any other
> arch then we have a biiiiig problem.  (Multiple instances of this)

Thanks, fixed!

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1835406229-1184835727=:8661--

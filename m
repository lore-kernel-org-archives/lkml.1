Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbXDXP4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbXDXP4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbXDXP4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:56:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:43633 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbXDXP4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:56:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="235871677:sNHT19335253"
Date: Tue, 24 Apr 2007 08:49:04 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Olivier Galibert <galibert@pobox.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com
Subject: Re: [patch 1/7] libata: check for AN support
Message-Id: <20070424084904.61932994.kristen.c.accardi@intel.com>
In-Reply-To: <20070424102304.GA58841@dspnet.fr.eu.org>
References: <20070424074856.005152262@intel.com>
	<20070423165943.0cc67bc5.kristen.c.accardi@intel.com>
	<20070424090713.65657495@the-village.bc.nu>
	<20070424102304.GA58841@dspnet.fr.eu.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 12:23:04 +0200
Olivier Galibert <galibert@pobox.com> wrote:

> Sorry for replying to Alan's reply, I missed the original mail.
> 
> > > +#define ata_id_has_AN(id)	\
> > > +	((id[76] && (~id[76])) & ((id)[78] & (1 << 5)))
> 
> (a && ~a) & (b & 32)
> 
> I don't think that does what you think it does, because at that point
> it's a funny way to write 0 ((0 or 1) binary-and (0 or 32)).
> 
> I'm not even sure what it is you want.  If for the first part you
> wanted (id[76] != 0x00 && id[76] != 0xff), please write just that,
> thanks :-)
> 
>   OG.
> 

>From the serial ata spec, we have:

13.2.1.18        Word 78: Serial ATA features supported
If Word 76 is not 0000h or FFFFh, Word 78 reports the optional features 
supported by the device.  Support for this word is optional and if not 
supported the word shall be zero indicating the device has no support for new 
Serial ATA capabilities.

so, basically yes, I'm really testing to make sure that word 76 isn't 0 or all
one then using that value & with value of bit in work 78 to determine AN
support - if you think this is really obfuscated, I've got no problem changing 
it - there's obviously many ways to mess around with bits.

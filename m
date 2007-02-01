Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532AbXBAVtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbXBAVtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbXBAVtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:49:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:39895 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbXBAVti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:49:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,269,1167638400"; 
   d="scan'208"; a="191730712:sNHT26625165"
Date: Thu, 1 Feb 2007 13:49:18 -0800
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: "Andy Currid" <ACurrid@nvidia.com>
Cc: "Jeff Garzik" <jeff@garzik.org>, "Peer Chen" <pchen@nvidia.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Prakash Punnoor" <prakash@punnoor.de>, "Andrew Morton" <akpm@osdl.org>,
       <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       "Kuan Luo" <kluo@nvidia.com>
Subject: Re: [PATCH] SCSI: Add the SGPIO support for sata_nv.c
Message-Id: <20070201134918.29019cfe.kristen.c.accardi@intel.com>
In-Reply-To: <8E5ACAE05E6B9E44A2903C693A5D4E8A1CB6ABCE@hqemmail02.nvidia.com>
References: <15F501D1A78BD343BE8F4D8DB854566B0CEB90E0@hkemmail01.nvidia.com>
	<455DF9AE.3000406@garzik.org>
	<20070131152136.7d0a05ff.kristen.c.accardi@intel.com>
	<8E5ACAE05E6B9E44A2903C693A5D4E8A1CB6ABCE@hqemmail02.nvidia.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 11:55:35 -0800
"Andy Currid" <ACurrid@nvidia.com> wrote:

> 
> I'm not sure I understand your point. To support SGPIO initiators
> incorporated
> into SATA host controllers, it is pretty much inevitable that some SGPIO
> support
> will have to be added directly into individual drivers for thoese
> controllers;

If SGPIO is defined as a generic protocol, could there be bits that are
used universally by all controllers that support a SGPIO interface, and
then of course chipset specific bits as far as how this is used?  For
example, AHCI 1.1 specifies that Enclosure Management via SGPIO is 
supported, and uses the message interface defined in SFF-8485.  If there
are any parts to your implementation that are remotely standard, it would
be preferrable in my opinion to split them out into a separate file
so that you have vendor specific code in the driver, and generic sgpio
defines in a separate file that can be shared somehow.

Probably I should have more appropriately asked whether there were any
bits in this that could be made common :).

Kristen

> the SGPIO standard does not define a register level interface for
> accessing
> this functionality, so vendor implementations vary.
> 
> It's possible that with an SGPIO initiator integrated within a SAS host
> controller,
> you may be able to use SMP frames to access it, using the messaging
> defined in
> SFF-8485 chapter 8 - but I wouldn't bank on it.
> 
> Andy
> 
> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Kristen Carlson
> Accardi
> Sent: Wednesday, January 31, 2007 15:22
> To: Jeff Garzik
> Cc: Peer Chen; Christoph Hellwig; Prakash Punnoor; Andrew Morton;
> linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org; Kuan Luo
> Subject: Re: [PATCH] SCSI: Add the SGPIO support for sata_nv.c
> 
> On Fri, 17 Nov 2006 13:04:30 -0500
> Jeff Garzik <jeff@garzik.org> wrote:
> 
> > Peer Chen wrote:
> > > I didn't get any comment from you guys for new patch, does someone
> take
> > > care this patch, do we still need some modification upon it? Or do
> we
> > > need re-submit it in other thread?
> > 
> > For my part, it's in my queue of things to review.  I need to figure
> out 
> > the best way to export this support.
> > 
> > 	Jeff
> 
> Adding SGPIO support directly into an individual SATA driver seems to be
> a very bad idea since SGPIO is a) a protocol that can be used by many 
> different SATA controllers and is not nvidia specific and b) can also
> be used by SAS.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> -----------------------------------------------------------------------------------
> This email message is for the sole use of the intended recipient(s) and may contain
> confidential information.  Any unauthorized review, use, disclosure or distribution
> is prohibited.  If you are not the intended recipient, please contact the sender by
> reply email and destroy all copies of the original message.
> -----------------------------------------------------------------------------------
> 

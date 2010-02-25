Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab0BYObm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 09:31:42 -0500
Received: from mxout.mainstreet.net ([207.5.0.25]:62749 "EHLO
	mxout1.mainstreet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab0BYObl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 09:31:41 -0500
X-Greylist: delayed 731 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Feb 2010 09:31:41 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/7] RapidIO: Add IDT CPS/TSI switches
Date: Thu, 25 Feb 2010 06:18:49 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552A54E7A@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4B8585DE.50701@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/7] RapidIO: Add IDT CPS/TSI switches
thread-index: Acq1jF/s4OLjUPyhTUaNe598e6iZ+gAlMa5Q
References: <20100224151447.GA13661@kaneng01.tundra.com> <4B8585DE.50701@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@IDT.COM>
To: "Micha Nelissen" <micha@neli.hopto.org>,
       "Alexandre Bounine" <alexb@tundra.com>
Cc: <mporter@kernel.crashing.org>, <alexandreb@tundra.com>,
       <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
       <thomas.moll.ext@nsn.com>, <thomas.moll@sysgo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
> Alexandre Bounine wrote:
> > @@ -369,6 +380,10 @@ static struct rio_dev __devinit *rio_set
> >  			     rdev->rswitch->switchid);
> >  		rio_route_set_ops(rdev);
> >
> > +		if (do_enum && rdev->rswitch->clr_table)
> > +			rdev->rswitch->clr_table(port, destid, hopcount,
> > +						 RIO_GLOBAL_TABLE);
> > +
> >  		list_add_tail(&rswitch->node, &rio_switches);
> >
> >  	} else
> 
> Why clear the tables here, why not in rio_enum_peer?

I prefer to keep it together with route table image initialization. 

> 
> > +DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI572,
tsi57x_route_add_entry,
> tsi57x_route_get_entry, tsi57x_route_clr_table);
> > +DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI574,
tsi57x_route_add_entry,
> tsi57x_route_get_entry, tsi57x_route_clr_table);
> > +DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI577,
tsi57x_route_add_entry,
> tsi57x_route_get_entry, tsi57x_route_clr_table);
> > +DECLARE_RIO_ROUTE_OPS(RIO_VID_TUNDRA, RIO_DID_TSI578,
tsi57x_route_add_entry,
> tsi57x_route_get_entry, tsi57x_route_clr_table);
> 
> Can the 568 and 578 driver be shared? Have a 5xx driver?

For route table operations this will work. But there are Error
Management functions added in follow-up patches, which are different for
Tsi568. I prefer to keep them in different files to avoid hiding the
differences. Plus, it makes easier for end-user to remove from the build
drivers for switches that are not used in their system. I do not want to
add new configuration options for switch selection at this moment but we
may consider it later. 

Alex.
  

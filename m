Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbXJIR7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbXJIR7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXJIR7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:59:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:50198 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbXJIR7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:59:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,249,1188802800"; 
   d="scan'208";a="167973222"
Date: Tue, 9 Oct 2007 10:53:57 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] ata: libata: add per device private data
Message-Id: <20071009105357.23e95e41.kristen.c.accardi@intel.com>
In-Reply-To: <47025EB2.6010606@pobox.com>
References: <20070924162314.408ece21.kristen.c.accardi@intel.com>
	<47025EB2.6010606@pobox.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay in responding, I was on vacation.

On Tue, 02 Oct 2007 11:07:30 -0400
Jeff Garzik <jgarzik@pobox.com> wrote:

> Kristen Carlson Accardi wrote:
> > Allow host controllers to store private data per device.
> > 
> > Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> > 
> > ---
> >  include/linux/libata.h |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > Index: libata-dev/include/linux/libata.h
> > ===================================================================
> > --- libata-dev.orig/include/linux/libata.h	2007-09-24 16:13:33.000000000 -0700
> > +++ libata-dev/include/linux/libata.h	2007-09-24 16:15:24.000000000 -0700
> > @@ -474,6 +474,9 @@ struct ata_device {
> >  	/* error history */
> >  	struct ata_ering	ering;
> >  	int			spdn_cnt;
> > +
> > +	/* controller driver per device private data */
> > +	void 			*private_data;
> 
> I don't have any objections to this per se...  a lot of other subsystems 
> do this too, and I can certainly see a potential need.
> 
> But what about object lifetimes?  If a controller is hot-unplugged, does 
> anyone need notification to destroy dynamic objects, or does controller 
> cleanup take care of that?  If a device is unplugged, where should a 
> controller driver do its ->private_data cleanup?
> 
> This is /not/ a NAK, just a request to make clear the lifetime rules and 
> procedures...
> 
> 	Jeff
> 

I'll do this - and meanwhile go ahead and ignore this patch.  I've decided
to submit it as part of a series where I actually use the private data,
so we can review it in context.

Thanks,
Kristen

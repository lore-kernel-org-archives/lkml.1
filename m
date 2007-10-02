Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbXJBPHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbXJBPHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXJBPHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:07:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36625 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbXJBPHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:07:34 -0400
Message-ID: <47025EB2.6010606@pobox.com>
Date: Tue, 02 Oct 2007 11:07:30 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] ata: libata: add per device private data
References: <20070924162314.408ece21.kristen.c.accardi@intel.com>
In-Reply-To: <20070924162314.408ece21.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> Allow host controllers to store private data per device.
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> 
> ---
>  include/linux/libata.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: libata-dev/include/linux/libata.h
> ===================================================================
> --- libata-dev.orig/include/linux/libata.h	2007-09-24 16:13:33.000000000 -0700
> +++ libata-dev/include/linux/libata.h	2007-09-24 16:15:24.000000000 -0700
> @@ -474,6 +474,9 @@ struct ata_device {
>  	/* error history */
>  	struct ata_ering	ering;
>  	int			spdn_cnt;
> +
> +	/* controller driver per device private data */
> +	void 			*private_data;

I don't have any objections to this per se...  a lot of other subsystems 
do this too, and I can certainly see a potential need.

But what about object lifetimes?  If a controller is hot-unplugged, does 
anyone need notification to destroy dynamic objects, or does controller 
cleanup take care of that?  If a device is unplugged, where should a 
controller driver do its ->private_data cleanup?

This is /not/ a NAK, just a request to make clear the lifetime rules and 
procedures...

	Jeff




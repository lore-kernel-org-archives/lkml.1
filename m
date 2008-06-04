Return-Path: <linux-kernel-owner+w=401wt.eu-S1762861AbYFDXjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861AbYFDXjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757810AbYFDXi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:38:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:44388 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543AbYFDXiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:38:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=kImtD6C1d2sx5sOG8HYTEcBEJDnGRh6LTx+mAuF4CAdE965yB1roLyRB3VRfZrgBbB
         UPQoD3br6ESXpDaIe/VjTW+g1C9CuONZANfeak38Li6CHhEsDyyndVaFsC88XzbV86iY
         C2BUtUsPyj+SByNKbTcJTju5nhYZ4EhibTLSI=
Message-ID: <12c511ca0806041638t1dace5c1i3831297305670ae4@mail.gmail.com>
Date: Wed, 4 Jun 2008 16:38:53 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my ALSA intel8x0 sound card regression
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Avuton Olrich" <avuton@gmail.com>,
       "Rene Herman" <rene.herman@keyaccess.nl>,
       "Rene Herman" <rene.herman@gmail.com>,
       "Len Brown" <len.brown@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200806021642.50491.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com>
	 <200806021605.14519.bjorn.helgaas@hp.com>
	 <3aa654a40806021523k5b89cd0cjbcddf5810d05072b@mail.gmail.com>
	 <200806021642.50491.bjorn.helgaas@hp.com>
X-Google-Sender-Auth: d8892e0736402b03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is now in Linus tree (commit 4b34fe156455d26ee6ed67b61539f136bf4e439c)

> --- work11.orig/drivers/pnp/system.c    2008-06-02 14:58:56.000000000 -0600
> +++ work11/drivers/pnp/system.c 2008-06-02 15:44:36.000000000 -0600
> @@ -81,7 +81,7 @@ static void reserve_resources_of_dev(str
>        }
>
>        for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
> -               if (res->flags & IORESOURCE_UNSET)
> +               if (res->flags & IORESOURCE_DISABLED)

but this change is responsible for a slew of console messages during
boot like this
on my Tiger4:

system 00:01: iomem range 0x0-0x0 has been reserved
system 00:01: iomem range 0x0-0x0 has been reserved
system 00:01: iomem range 0x0-0x0 has been reserved
system 00:01: iomem range 0x0-0x0 has been reserved
system 00:01: iomem range 0x0-0x0 has been reserved
system 00:01: iomem range 0x0-0x0 has been reserved
system 00:01: iomem range 0x0-0x0 has been reserved
system 00:01: iomem range 0x0-0x0 has been reserved
system 00:01: iomem range 0x0-0x0 has been reserved
 ... continues for total of 46 lines

-Tony

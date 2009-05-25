Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZEYWTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZEYWTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZEYWTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:19:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34422 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752609AbZEYWTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:19:15 -0400
Date: Mon, 25 May 2009 23:20:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Jacob <fun2program8@yahoo.com>,
       Christopher Hogan <chris.c.hogan@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: add warning about possible HPA compatibility
 issue
Message-ID: <20090525232014.7b6dd7bd@lxorguk.ukuu.org.uk>
In-Reply-To: <200905252348.08970.bzolnier@gmail.com>
References: <200905252348.08970.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline void ata_hpa_warn(unsigned long long first_sector,
> +				unsigned long long last_sector)
> +{
> +	printk(KERN_WARNING "*** possible compatibility issue:\n"
> +		"*** sectors %llu-%llu may be inaccessible\n"
> +		"*** if Host Protected Area is used for filesystem data\n"
> +		"*** (please refer to \"ignore_hpa\" module parameter)\n",
> +		first_sector, last_sector);
> +}

NAK - this is extremely misleading and will just randomly terrify users,
who may then set the paramater and corrupt things like BIOS save areas.

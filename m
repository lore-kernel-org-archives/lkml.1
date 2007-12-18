Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbXLRJ4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbXLRJ4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 04:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXLRJ4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 04:56:31 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:59565 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbXLRJ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 04:56:30 -0500
Date: Tue, 18 Dec 2007 12:56:43 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, jgarzik@pobox.com,
       wingel@nano-system.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       james.smart@emulex.com, linux-driver@qlogic.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 4/4] [POWERPC] pci: Disable IO/Mem on a device when resources can't be allocated
Message-ID: <20071218125643.B7874@jurassic.park.msu.ru>
References: <1197932473.576079.142524077033.qpush@grosgo> <20071217230127.46B3BDDE38@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20071217230127.46B3BDDE38@ozlabs.org>; from benh@kernel.crashing.org on Tue, Dec 18, 2007 at 10:01:15AM +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 10:01:15AM +1100, Benjamin Herrenschmidt wrote:
> @@ -1040,7 +1040,10 @@ static inline void __devinit alloc_resou
>  		r->flags |= IORESOURCE_UNSET;
>  		r->end -= r->start;
>  		r->start = 0;

Perhaps we should use IORESOURCE_UNSET universally... It's a lot better
than clearing r->start which is in fact architecture dependent thing
and in the end just destroys information for no purpose.

Ivan.

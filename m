Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbXEYM06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbXEYM06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759928AbXEYM0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:26:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54321 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759830AbXEYM0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:26:47 -0400
Message-ID: <4656D602.3010105@garzik.org>
Date: Fri, 25 May 2007 08:26:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: always use polling SETXFER
References: <20070314053338.GA15600@htj.dyndns.org> <4656C144.2080705@garzik.org> <4656CF83.5020402@gmail.com>
In-Reply-To: <4656CF83.5020402@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> So, I don't think the problem exists for SATA in the first place.  At
> least there hasn't been any report of it and doing SETXFER by polling
> can handle all the existing cases.  We can and probably should deal with
> such SATA devices when and if they come up.  How are we gonna verify the
> controller doesn't crap itself and ahci TF register monitoring HSM can
> work around the weirdo when we don't have any such device?  Even if we
> determine that we need to do HSM over intelligent SATA controller now, I
> think we still need to push polling SETXFER first to take care of the
> existing cases.

Doing SETXFER by polling only handles the cases where the driver 
actually honors ATA_TFLAG_POLLING, which is /not/ always the case.

If the new policy ensures that it continues to be OK to /not/ honor 
ATA_TFLAG_POLLING -- thus limiting SETXFER polling assumptions to older 
hardware -- that's fine, and it merely needs to be documented.

But let us not make the assumption that this bandaid fixes all cases, 
because the bandaid is not applied in all cases.

	Jeff



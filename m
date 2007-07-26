Return-Path: <linux-kernel-owner+w=401wt.eu-S934704AbXGZUAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934704AbXGZUAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933556AbXGZT7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:59:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:62760 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936091AbXGZT7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:59:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=qdaKXP0aSYrtgWFg+Re8SIvxTTKlJsW1VRIHCpYsvhPBlG81rUolEIXvA6soSOD7SMgYDA612urU67SwOq9B4oPJy/2NqUiBchYFLWHjM3pmIy1JJWsI3yVyEhd0p9X7DJXVMf2UjD7fhE9h/aKtZgGgeK0DXAUljnrF2rrUgrs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: drivers/ide/pci/cs5535.c: array overrun
Date: Thu, 26 Jul 2007 21:11:21 +0200
User-Agent: KMail/1.9.6
Cc: bunk@stusta.de, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <06FDA0246543E443ABBB36B1FCD5CC0603CF3360@SAUSEXMB2.amd.com> <20070724155952.GA13874@cosmic.amd.com>
In-Reply-To: <20070724155952.GA13874@cosmic.amd.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707262111.21296.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 24 July 2007, Jordan Crouse wrote:
> > The Coverity checker spotted the following array overrun in 
> > drivers/ide/pci/cs5535.c:
> 
> <-- snip -->
> 
> >	if (speed >= XFER_UDMA_0 && speed <= XFER_UDMA_7)
> >		reg |= cs5535_udma_timings[speed - XFER_UDMA_0];

Not a bug per se since the upper layer will never feed this function
with speed > XFER_UDMA_4 (thanks to ->ultra_mask being set to 0x1f).

Worth fixing anyway.

> Fix is attached.  Somebody got overzealous - the 5535 only supports
> up to UDMA4, which matches the array.

applied, thanks

Bart

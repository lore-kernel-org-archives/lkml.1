Return-Path: <linux-kernel-owner+w=401wt.eu-S1764895AbYBVTG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764895AbYBVTG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757049AbYBVTGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:06:17 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:37535 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757451AbYBVTGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:06:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=bpNUYdWnIZRc2sdqqYcKmrkb54JP4prkY7Pldh2B84495SK8+lQe+mFF1YXvbJRUmLhIXZ+xO2n9CMuhPLkXcvlfyztBqLi69ClJYhs+wPRNPaCwm/Qy4x2J3hET+d39sRAmGlXJ0Hi1R+BPFNcO5spdedQSRchjidEq5PGmfVI=  ;
X-YMail-OSG: .NsbU9AVM1lyGFT7lwYsYicU7plI1UwsB4DL1JkUQSB3_Y.U8V4YMmQDZkKw9euXYyFv.N8Ggg--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 22 Feb 2008 11:06:13 -0800
From: David Brownell <david-b@pacbell.net>
To: nforrester@whoi.edu, anemo@mba.ocn.ne.jp
Subject: Re: [spi-devel-general] [PATCH] atmel_spi: support zero length	
 transfer
Cc: spi-devel-general@lists.sourceforge.net, marc.pignat@hevs.ch,
       linux-kernel@vger.kernel.org
References: <200802211026.17816.marc.pignat@hevs.ch>
 <20080221192334.EE97A230A58@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <200802221030.32263.marc.pignat@hevs.ch>
 <20080222.231510.56565462.anemo@mba.ocn.ne.jp>
 <47BEDBFB.5040305@whoi.edu>
In-Reply-To: <47BEDBFB.5040305@whoi.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080222190613.0043B229B4D@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If the driver could not handle zero length transfer, then the driver
> > should reject it (just like unsupported transfer mode).  Then the
> > behavior will be 'assert chip select and wait some time' or 'rejected
> > by the driver'.
>
> This would be OK.  It would not be hard to fix pxa2xx_spi, for example,
> to reject zero-length transfers in DMA mode, as long as it is acceptable
> to reject the message in mid-message.

Such "illegal message" rejection is best done early; "fail-fast".
Mid-message rejection isn't wrong, but it's a rude policy.

It'd be best to fix pxa2xx_spi to not start zero-length DMAs.


>	If it were necessary to scan a
> whole message for zero-length transfers and refuse to queue an offending
> message, then that adds burden to all messages.

Sanity checking messages as they're submitted is easy; and it's
also the natural point for setting up DMA mappings (and making
those cachelines available for better use).

- Dave


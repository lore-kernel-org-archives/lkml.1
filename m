Return-Path: <linux-kernel-owner+w=401wt.eu-S1758481AbXIUNWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481AbXIUNWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931AbXIUNWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:22:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:10476 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbXIUNWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tcwH7jBh6iNk3dgDcNrbnETjmSbPZ/Dg0IObJQPH75DtMn9x/2CwvHirPjMj4H7sHytu8f20acs9ME1pXJc7VLibnGoOgOTRLEdxqlLWNxLSaxlxqa5A3DurI3UZIPPiiZ3TvWesIkZdmTXO7qc9xOKjn6Df/9p2mEALfe01HN4=
Message-ID: <a71b7b480709210622l23481221pd09302a827b55eb@mail.gmail.com>
Date: Fri, 21 Sep 2007 14:22:44 +0100
From: "Peter Fordham" <peter.fordham@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: fpu IO port reservation (arch/i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Does anybody know why we reserve this range of IO ports for 'fpu'?
AFAIK from all the IO maps I can find on the internet for various x86
chipsets only 0x00f0 is actaully ever used.

./arch/i386/kernel/setup.c
282 }, {
283         .name   = "fpu",
284         .start  = 0x00f0,
285         .end    = 0x00ff,
286         .flags  = IORESOURCE_BUSY | IORESOURCE_IO
287 } };

The reason I ask is that I've written a watchdog driver for a Nexcom
MAX6600 server blade type device which has the watchdog control
register at 0xF2. Currently request_region fails due to the fpu
reservation.

regards,

Pete Fordham

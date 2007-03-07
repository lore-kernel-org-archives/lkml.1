Return-Path: <linux-kernel-owner+w=401wt.eu-S1422746AbXCGR4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422746AbXCGR4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422770AbXCGRzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:55:52 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:45701 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422746AbXCGRze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:55:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rCa5pPVTnMSaNCDR7QS7xGtJ8eBIcmPuCelL/NUTOZcq8jdAeg9h3J2KqAfrI8CjELVjsRhcXgd189l9JD4kkfJxDKZjN3UhOOxCZSiHSZP7mWCmsE/QiNh1c8MYO/nmcQ1MQnDFfXZ2inJ0nTgFsuidGRrhrf/1bVe94JRsOtM=  ;
X-YMail-OSG: U84K3OYVM1lwYUvqM0oGI.efKnjRSfiy7Ktq4lMipuOTxWm.hZf5ykwqFBAyuU8dyCD4BjX7sxCqx_NooRyLttn6FzbhwNyNIBI4dZV.m.mkGP1Mn.XfA8OM6cfK7ox_gQ8AXI1dNJMQgN4-
From: David Brownell <david-b@pacbell.net>
To: ngustavson@emacinc.com
Subject: Re: passing function pointers through platform devices?
Date: Wed, 7 Mar 2007 09:55:30 -0800
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703070955.31370.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm developing an SPI- bus >MMC/SD block driver translation layer.

Another one?  There's already been significant work in that area.  See for
example

  http://marc.theaimsgroup.com/?l=linux-kernel&m=117000652529003&w=2

Which admittedly didn't behave when I just put it onto my test rig,
but seems nonetheless to be a significant step forward.  It's not like
everyone has hardware that can use such a driver after all!


> As part of this layer the write protect and card detect lines need to be read.
> The method for determining the state of these lines will be board specific.

Example, one usually wants card detect to be an IRQ, to avoid polling...


> Is it appropriate to pass a function pointer through a platform device 
> (declared in the mach initialization) to implement card_available and 
> write_protect function calls?

That's how it's done in that patch.  The model being what the PXA MMC/SD
card driver does, since that's the most generic model I found ... handling
for example systems which need to poll for card detect, as well as ones
that can use real gpio based IRQs.  The mmc_spi driver doesn't need to know
which kind of platform it's got.

- Dave



 

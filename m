Return-Path: <linux-kernel-owner+w=401wt.eu-S936152AbYEUTeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936152AbYEUTeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbYEUTdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:33:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:31285 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729AbYEUTdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:33:49 -0400
Message-ID: <fa686aa40805211233h72a258bpf8c945b9f662d6ee@mail.gmail.com>
Date: Wed, 21 May 2008 13:33:31 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Segher Boessenkool" <segher@kernel.crashing.org>
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linuxppc-dev@ozlabs.org,
       fabrizio.garetto@gmail.com
In-Reply-To: <716a0f1b6c9a544b480c06a329072483@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca>
	 <20080516193613.28030.13950.stgit@trillian.secretlab.ca>
	 <Pine.LNX.4.64.0805191446530.27140@axis700.grange>
	 <fa686aa40805190857u317d3304ie75d11870e109fc5@mail.gmail.com>
	 <Pine.LNX.4.64.0805191811510.29559@axis700.grange>
	 <fa686aa40805192213y485c4ba2u750748f8201e0377@mail.gmail.com>
	 <Pine.LNX.4.64.0805201650280.5283@axis700.grange>
	 <716a0f1b6c9a544b480c06a329072483@kernel.crashing.org>
X-Google-Sender-Auth: 7354bfe48c988257
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 1:11 PM, Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>> Ok, elegance apart:-) You can use the SPI-bridge construct to also
>> describe simple SPI-chipselect configurations. But is it really a good
>> idea? Wouldn't it be better to handle these two cases separately?
>
> It would be best to handle all these things that are specific to
> a certain SPI controller (like how CSs work) in the binding for
> that SPI controller, and not try to shoehorn all of this into some
> artificial generic framework.
>
> If you can have identical addresses on the SPI bus going to different
> devices based on which CS is asserted, you'll have to make the CS part
> of the "reg".  Example:
>
> spi-controller {
>        #address-cells = 2;
>        #size-cells = 0;
>        some-device@0,f000 { reg = < 0 f000 >; } // CS 0, SPI address f000
>        some-device@1,f000 { reg = < 1 f000 >; } // CS 1, SPI address f000
>        some-device@1,ff00 { reg = < 1 ff00 >; } // CS 1, SPI address ff00
> }

For SPI the CS # *is* the address.  :-)

Unlike I2C, SPI doesn't impose any protocol on the data.  It is all
anonymous data out, anonymous data in, a clock and a chip select.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

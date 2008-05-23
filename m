Return-Path: <linux-kernel-owner+w=401wt.eu-S1765465AbYEWDiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765465AbYEWDiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 23:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761029AbYEWDhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 23:37:23 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:23872 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760610AbYEWDhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 23:37:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KPOE9il2yWIS7a+3IEMqfJ8d2F/FiuaiJ2ICZbDLq0TYpPaHWmRPduU6bYvwnN3bze+4VgGcOUMJ8AWZh8SaTzE49URwF0lqC1ho5p+7aqp4/m5mpm+WDS3SVVmtwW66Kpp4JE/5u/1FALaYE0dbJtbTCcRvzzA3muj8soxrc9c=  ;
X-YMail-OSG: iYwHLo0VM1mGgi7stQ7MWhUnXpS_lsl2vHNVa2K0xtfEMrROW5xrcJKafPlv8sUYSXTEszcZNn3mL_J78TAfdOJQh5tAeJWOnbF.ic6Y2GyCKuzbV9qWDGp_sDOLbjf4M9Y-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: spi-devel-general@lists.sourceforge.net
Subject: Re: [spi-devel-general] [PATCH 3/4] spi: Add OF binding support for SPI busses
Date: Thu, 22 May 2008 19:26:23 -0700
User-Agent: KMail/1.9.9
Cc: "Grant Likely" <grant.likely@secretlab.ca>,
       "Segher Boessenkool" <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       fabrizio.garetto@gmail.com,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> <716a0f1b6c9a544b480c06a329072483@kernel.crashing.org> <fa686aa40805211233h72a258bpf8c945b9f662d6ee@mail.gmail.com>
In-Reply-To: <fa686aa40805211233h72a258bpf8c945b9f662d6ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805221926.24112.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2008, Grant Likely wrote:
> > spi-controller {
> >        #address-cells = 2;
> >        #size-cells = 0;
> >        some-device@0,f000 { reg = < 0 f000 >; } // CS 0, SPI address f000
> >        some-device@1,f000 { reg = < 1 f000 >; } // CS 1, SPI address f000
> >        some-device@1,ff00 { reg = < 1 ff00 >; } // CS 1, SPI address ff00
> > }
> 
> For SPI the CS # *is* the address.  :-)
> 
> Unlike I2C, SPI doesn't impose any protocol on the data.  It is all
> anonymous data out, anonymous data in, a clock and a chip select.

Very true ... but then there are SPI chips which embed addressing.

I have in mind the mcp23s08 (and mcp23s17) GPIO expanders, which
support up to four chips wired in parallel on a given chipselect.
The devices are distinguished by how two address pins are wired;
and two bits in the command byte must match them.  (I think they
just recycled an I2C design into the SPI world.)

- Dave

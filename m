Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYGDD7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYGDD7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 23:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbYGDD7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 23:59:15 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:36416 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYGDD7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 23:59:15 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 3/5] of-bindings: Add binding documentation for SPI bussesand devices
Date: Fri, 4 Jul 2008 11:59:07 +0800
Message-ID: <58A20A281BAF1047B4EAE68DE5C0BDC2010121B9@zch01exm21.fsl.freescale.net>
In-Reply-To: <20080703010308.26187.23037.stgit@trillian.secretlab.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 3/5] of-bindings: Add binding documentation for SPI bussesand devices
Thread-Index: AcjcqXrNF41PL+6bR1a9aFaaBjsRBAA4F7rQ
References: <20080703005749.26187.71719.stgit@trillian.secretlab.ca> <20080703010308.26187.23037.stgit@trillian.secretlab.ca>
From: "Chen Gong" <G.Chen@freescale.com>
To: "Grant Likely" <grant.likely@secretlab.ca>, <linuxppc-dev@ozlabs.org>,
       <spi-devel-general@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Cc: <david-b@pacbell.net>, <fabrizio.garetto@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: linuxppc-dev-bounces+b11801=freescale.com@ozlabs.org 
> [mailto:linuxppc-dev-bounces+b11801=freescale.com@ozlabs.org] 
> On Behalf Of Grant Likely
> Sent: 2008?7?3? 9:03
> To: linuxppc-dev@ozlabs.org; 
> spi-devel-general@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Cc: david-b@pacbell.net; fabrizio.garetto@gmail.com
> Subject: [PATCH v2 3/5] of-bindings: Add binding 
> documentation for SPI bussesand devices
> 
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> Add documentation about how to describe SPI busses in the device tree.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
>  Documentation/powerpc/booting-without-of.txt |   60 
> ++++++++++++++++++++++++++
>  1 files changed, 60 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/powerpc/booting-without-of.txt 
> b/Documentation/powerpc/booting-without-of.txt
> index 1d2a772..7d3564f 100644
> --- a/Documentation/powerpc/booting-without-of.txt
> +++ b/Documentation/powerpc/booting-without-of.txt
> @@ -58,6 +58,7 @@ Table of Contents
>        o) Xilinx IP cores
>        p) Freescale Synchronous Serial Interface
>  	  q) USB EHCI controllers
> +      t) SPI busses
>  
>    VII - Marvell Discovery mv64[345]6x System Controller chips
>      1) The /system-controller node
> @@ -2870,6 +2871,65 @@ platforms are moved over to use the 
> flattened-device-tree model.
>  		reg = <0xe8000000 32>;
>  	};
>  
> +    t) SPI (Serial Peripheral Interface) busses
> +
> +    SPI busses can be described with a node for the SPI master device
> +    and a set of child nodes for each SPI slave on the bus.  For this
> +    discussion, it is assumed that the system's SPI controller is in
> +    SPI master mode.  This binding does not describe SPI controllers
> +    in slave mode.
> +
> +    The SPI master node requires the following properties:
> +    - #address-cells  - number of cells required to define a 
> chip select
> +			address on the SPI bus.
> +    - #size-cells     - should be zero.
> +    - compatible      - name of SPI bus controller following 
> generic names
> +			recommended practice.
> +    No other properties are required in the SPI bus node.  
> It is assumed
> +    that a driver for an SPI bus device will understand that 
> it is an SPI bus.
> +    However, the binding does not attempt to define the 
> specific method for
> +    assigning chip select numbers.  Since SPI chip select 
> configuration is
> +    flexible and non-standardized, it is left out of this 
> binding with the
> +    assumption that board specific platform code will be 
> used to manage
> +    chip selects.  Individual drivers can define additional 
> properties to
> +    support describing the chip select layout.
> +
> +    SPI slave nodes must be children of the SPI master node and can
> +    contain the following properties.
> +    - reg             - (required) chip select address of device.
> +    - compatible      - (required) name of SPI device 
> following generic names
> +			recommended practice
> +    - max-speed       - (required) Maximum SPI clocking 
> speed of device in Hz
> +    - spi,cpol        - (optional) Device requires inverse 
> clock polarity
> +    - spi,cpha        - (optional) Device requires shifted 
> clock phase
> +    - linux,modalias  - (optional, Linux specific) Force 
> binding of SPI device
> +			to a particular spi_device driver.  
> Useful for changing
> +			driver binding between spidev and a 
> kernel SPI driver.
> +

How about adding a "model" property to describe actual devie type.
Such as using a "sst25vf040b" device with spi-interface, we can
use model="sst25vf040b" to describe it.

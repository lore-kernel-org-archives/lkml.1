Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0CIQ7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:59:22 -0500
Received: from p01c12o149.mxlogic.net ([208.65.145.72]:47158 "EHLO
	p01c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab0CIQ7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:59:20 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2010 11:59:19 EST
X-MXL-Hash: 4b967e671cc64bee-5df3456274feb79357ec859d5c84b9e9e162491d
X-MXL-Hash: 4b967c7a220f2cac-3dad1174ed8a3e2ff58446df4927135c87d22e74
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
CC: Paul Mundt <lethal@linux-sh.org>
Date: Tue, 9 Mar 2010 10:50:32 -0600
Subject: RE: [PATCH] mfd: Fix sm501 requested region size
Thread-Topic: [PATCH] mfd: Fix sm501 requested region size
Thread-Index: Acq/X8T4naBT+4NYToCCWkZ7JMa3LgASLIUg
Message-ID: <0D753D10438DA54287A00B02708426976367AEB618@AUSP01VMBX24.collaborationhost.net>
References: <20100309080952.GA16041@sortiz.org>
In-Reply-To: <20100309080952.GA16041@sortiz.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010030401)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.69]
X-AnalysisOut: [v=1.0 c=1 a=hSlg8gjesYgA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=TYbMNos9eHUa9bm6/o8foQ==:17 a=QyXUC8HyAAAA:8 a=i00]
X-AnalysisOut: [gxMtYAAAA:8 a=_VeMih7w3mu1vw_Xc68A:9 a=GfSicxviGhyRh8o3GEc]
X-AnalysisOut: [GjG5Foz0A:4 a=CjuIK1q_8ugA:10 a=x1WnkoZAwusA:10 a=OqPxtxAp]
X-AnalysisOut: [KeaTOg2D:21 a=lX-HuMbwmRR7VML_:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 09, 2010 1:10 AM, Samuel Ortiz wrote:
>
> We should only request for the MFD used region, not the whole thing.
>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Sorry about that...

> ---
>  drivers/mfd/sm501.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
> index dc9ea95..497712f 100644
> --- a/drivers/mfd/sm501.c
> +++ b/drivers/mfd/sm501.c
> @@ -1430,7 +1430,7 @@ static int __devinit sm501_plat_probe(struct platform_device *dev)
>  	}
>  
>  	sm->regs_claim = request_mem_region(sm->io_res->start,
> -					    resource_size(sm->io_res), "sm501");
> +					    0x100, "sm501");
>  
>  	if (sm->regs_claim == NULL) {
>  		dev_err(&dev->dev, "cannot claim registers\n");
> @@ -1644,7 +1644,7 @@ static int __devinit sm501_pci_probe(struct pci_dev *dev,
>  	sm->mem_res = &dev->resource[0];
>  
>  	sm->regs_claim = request_mem_region(sm->io_res->start,
> -					    resource_size(sm->io_res), "sm501");
> +					    0x100, "sm501");
>  	if (sm->regs_claim == NULL) {
>  		dev_err(&dev->dev, "cannot claim registers\n");
>  		err= -EBUSY;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbXIKOwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbXIKOwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbXIKOvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:51:53 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:49826 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbXIKOvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:51:52 -0400
Date: Tue, 11 Sep 2007 09:51:31 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
Subject: Re: [PATCH 08/12] IB/ehca: Replace get_paca()->paca_index by the more portable smp_processor_id()
Message-ID: <20070911145131.GN32388@localdomain>
References: <200709111518.26276.fenkes@de.ibm.com> <200709111533.14333.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709111533.14333.fenkes@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Joachim Fenkes wrote:
> Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
> ---
>  drivers/infiniband/hw/ehca/ehca_tools.h |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/infiniband/hw/ehca/ehca_tools.h
> index f9b264b..863f972 100644
> --- a/drivers/infiniband/hw/ehca/ehca_tools.h
> +++ b/drivers/infiniband/hw/ehca/ehca_tools.h
> @@ -73,37 +73,37 @@ extern int ehca_debug_level;
>  		if (unlikely(ehca_debug_level)) \
>  			dev_printk(KERN_DEBUG, (ib_dev)->dma_device, \
>  				   "PU%04x EHCA_DBG:%s " format "\n", \
> -				   get_paca()->paca_index, __FUNCTION__, \
> +				   smp_processor_id(), __FUNCTION__, \
>  				   ## arg); \
>  	} while (0)
>  
>  #define ehca_info(ib_dev, format, arg...) \
>  	dev_info((ib_dev)->dma_device, "PU%04x EHCA_INFO:%s " format "\n", \
> -		 get_paca()->paca_index, __FUNCTION__, ## arg)
> +		 smp_processor_id(), __FUNCTION__, ## arg)
>  
>  #define ehca_warn(ib_dev, format, arg...) \
>  	dev_warn((ib_dev)->dma_device, "PU%04x EHCA_WARN:%s " format "\n", \
> -		 get_paca()->paca_index, __FUNCTION__, ## arg)
> +		 smp_processor_id(), __FUNCTION__, ## arg)
>  
>  #define ehca_err(ib_dev, format, arg...) \
>  	dev_err((ib_dev)->dma_device, "PU%04x EHCA_ERR:%s " format "\n", \
> -		get_paca()->paca_index, __FUNCTION__, ## arg)
> +		smp_processor_id(), __FUNCTION__, ## arg)

I think I see these macros used in preemptible code (e.g. ehca_probe),
where smp_processor_id() will print a warning when
CONFIG_DEBUG_PREEMPT=y.  Probably better to use raw_smp_processor_id.


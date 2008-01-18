Return-Path: <linux-kernel-owner+w=401wt.eu-S1763102AbYARXyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763102AbYARXyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 18:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759374AbYARXyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 18:54:41 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:52513 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317AbYARXyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 18:54:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=i4VqdY4hsy8ivRGZdvfa+Gwnb9XNS1BfxER4MliwjpSI0zo0ziuIlmq/fZhvTYFyDBGouWju0SR+w6POakFHJB+uYTzxU/bjR338sOkivEMqWZpBo1icHCVBr6qYUUxtjyKdBSdreZAxJQrRy2Q6QeeeKoIuhm/PKPRb7YBU/7U=
Message-ID: <47913C39.2070100@gmail.com>
Date: Sat, 19 Jan 2008 08:54:33 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, fischer@norbit.de,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [PATCH] SCSI: fix isa/pcmcia compile problem
References: <20080117023514.9df393cf.akpm@linux-foundation.org>	 <478F7F2B.9000801@linux.vnet.ibm.com>	 <20080117111104.3baa878e.akpm@linux-foundation.org>	 <47904927.1040000@linux.vnet.ibm.com>  <47905348.1000709@gmail.com>	 <1200668315.3111.3.camel@localhost.localdomain>	 <479135EE.2090009@gmail.com>	 <1200699173.3111.77.camel@localhost.localdomain> <1200700076.3111.80.camel@localhost.localdomain>
In-Reply-To: <1200700076.3111.80.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>> I'm just a bit reluctant to touch these drivers, since they're all
>> incredibly ancient.  We don't have good luck with simple transformation
>> patches on the older drivers ... and it seems to take months before
>> anyone notices there's a problem.
> 
> This is the patch that will return them to their original behaviour.
> 
> James
> 
> ---
> diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
> index fa481b5..53857c6 100644
> --- a/drivers/scsi/pcmcia/Kconfig
> +++ b/drivers/scsi/pcmcia/Kconfig
> @@ -6,7 +6,8 @@ menuconfig SCSI_LOWLEVEL_PCMCIA
>  	bool "PCMCIA SCSI adapter support"
>  	depends on SCSI!=n && PCMCIA!=n
>  
> -if SCSI_LOWLEVEL_PCMCIA && SCSI && PCMCIA
> +# drivers have problems when build in, so require modules
> +if SCSI_LOWLEVEL_PCMCIA && SCSI && PCMCIA && m
>  
>  config PCMCIA_AHA152X
>  	tristate "Adaptec AHA152X PCMCIA support"
> 
> 

Looks good to me.

-- 
tejun

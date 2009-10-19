Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZJSPFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZJSPFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZJSPFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:05:03 -0400
Received: from web50112.mail.re2.yahoo.com ([206.190.39.149]:27997 "HELO
	web50112.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756501AbZJSPFC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:05:02 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 11:05:02 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=17wksTGdRMpXdQOoV+UUgW8JY8U51N5w6IqGRcbFEfZXrEZ0xjZQJR4hypT62wkZ/ueifZtnwt1WqsZL+hzISShFNFuxBoM7tQQrJ/iVL9jEWCRbS39BsrTzzrSTo7TIDaMMLo+CUlp5UBBCU36ufqh689yxSGjiFFFdsSlzjCI=;
Message-ID: <989292.58968.qm@web50112.mail.re2.yahoo.com>
X-YMail-OSG: 4uK5cCAVM1k2SZxAGDUJFrUAvjyWAY.7dQR3yT05Ou1UNrLAJf.3pHyDVIQ7KEFUUH4Ey6G023_mfTHxH0R0bxXC36w1QmxnNmG3lfIgYjsNNpHLfbhIBRDfkqRiAb5.1WJUKi7t5nZGzSgB4YI6IWDJW7_SW51JDMm2in3Lftg4mil8AZ_wAWdLH_hD0qs_EntOdhNXFKhSkn8iqO5ow9LNw.VO2zKtfzUfHwEfGy.K5cFvCCXjulHSZey5wdQu2B_QE.8WIiEALZ_eLctpu1DLW5MhA22pCYacdMFsTFoeu6qQlpOVsAmvM.J_bBuZpLdsw0MOYFpaF4sbz14PZ2ihqx1X._OvOp5fR3NVYUnfGytFlh74PciZXjN5QIc2ToGX.kXWQ7Q5XHem77aTcTdlMT7IdCyRhf_XxTOVM2s-
X-Mailer: YahooMailClassic/8.0.7 YahooMailWebService/0.7.361.3
Date: Mon, 19 Oct 2009 07:58:24 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] amd64_edac: fix a wrong goto clause in amd64_edac.c
To: Borislav Petkov <borislav.petkov@amd.com>,
       Doug Thompson <dougthompson@xmission.com>, linux-kernel@vger.kernel.org,
       Li Hong <lihong.hi@gmail.com>
In-Reply-To: <20091019083329.GA7340@uhli>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 10/19/09, Li Hong <lihong.hi@gmail.com> wrote:

> From: Li Hong <lihong.hi@gmail.com>
> Subject: [PATCH] amd64_edac: fix a wrong goto clause in amd64_edac.c
> To: "Borislav Petkov" <borislav.petkov@amd.com>, "Doug Thompson" <dougthompson@xmission.com>, linux-kernel@vger.kernel.org
> Date: Monday, October 19, 2009, 2:33 AM
> In amd64_edac_init(void) in
> amd64_edac.c, cache_k8_northbridges() is called
> before pci_register_driver. If it fails, should exit with
> err directly.
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>

Acked-by: Doug Thompson <dougthompson@xmission.com>


> ---
>  drivers/edac/amd64_edac.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c
> b/drivers/edac/amd64_edac.c
> index d4560d9..3ee539a 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -3163,7 +3163,7 @@ static int __init
> amd64_edac_init(void)
>      opstate_init();
>  
>      if (cache_k8_northbridges() < 0)
> -        goto err_exit;
> +        return err;
>  
>      err =
> pci_register_driver(&amd64_pci_driver);
>      if (err)
> @@ -3189,8 +3189,6 @@ static int __init
> amd64_edac_init(void)
>  
>  err_2nd_stage:
>      debugf0("2nd stage failed\n");
> -
> -err_exit:
>     
> pci_unregister_driver(&amd64_pci_driver);
>  
>      return err;
> -- 
> 1.6.0.4
> 
> 

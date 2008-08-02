Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbYHBRCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbYHBRCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbYHBRCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:02:00 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:50055 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbYHBRB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:01:59 -0400
Date: Sat, 2 Aug 2008 19:01:48 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
cc: Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: acer-wmi broken in latest git kernel on TravelMate 6492
 (Insufficient arguments - method [WQAA])
In-Reply-To: <200808021728.46046.carlos@strangeworlds.co.uk>
Message-ID: <alpine.LNX.1.10.0808021859590.2294@titan.stealer.net>
References: <alpine.LNX.1.10.0808021640310.2294@titan.stealer.net> <200808021728.46046.carlos@strangeworlds.co.uk>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.7
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sat, 02 Aug 2008 17:01:57 +0000
	Bayes: 0.0151 Tokens: new, 226; hammy, 4; neutral, 3; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.3 SARE_SUB_OBFU_Q0 FVGT - subject contains odd letter combination
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0151]
X-Spam-Signature: ff15d85191a456733d57232903e03c2d9b2c8463
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2008, Carlos Corbacho wrote:

> On Saturday 02 August 2008 16:50:54 Sven Wegener wrote:
> > Is it a bug in acer-wmi or in Acer's ACPI implementation? I can provide 
> > more information as necessary.
> 
> Neither - it's a bug in wmi.c
> 
> Try the following patch:
> ---
> ACPI: WMI: Set instance for query block calls
> 
> From: Carlos Corbacho <carlos@strangeworlds.co.uk>
> 
> Although the necessary data structure was set up, it was never actually
> passed in, so data block calls have only been working by sheer chance.
> 
> (On Acer laptops. the data block methods we've been calling never look at
> the instance value, hence acer-wmi never triggered this before).
> 
> f3454ae8104efb2dbf0d08ec42c6f5d0fe9225bc brought this to light.
> 
> Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

Yep, that fixes it, thanks.

Tested-by: Sven Wegener <sven.wegener@stealer.net>

> diff --git a/drivers/acpi/wmi.c b/drivers/acpi/wmi.c
> index c33b1c6..cfe2c83 100644
> --- a/drivers/acpi/wmi.c
> +++ b/drivers/acpi/wmi.c
> @@ -347,7 +347,7 @@ struct acpi_buffer *out)
>  	strcpy(method, "WQ");
>  	strncat(method, block->object_id, 2);
>  
> -	status = acpi_evaluate_object(handle, method, NULL, out);
> +	status = acpi_evaluate_object(handle, method, &input, out);
>  
>  	/*
>  	 * If ACPI_WMI_EXPENSIVE, call the relevant WCxx method, even if

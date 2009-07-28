Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbZG1Qbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbZG1Qbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZG1Qbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:31:41 -0400
Received: from outbound-mail-122.bluehost.com ([67.222.38.22]:44709 "HELO
	outbound-mail-122.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751396AbZG1Qbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:31:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=C0u0evYCvIRTfCzUe84biA8hGGDmfO2BkcZ3GyyUpnyX60hLp1Ath46RnD/WWwa+ReZ/yQBAaWCNhZRVX+4+yIW2jdrphIKeI5hFNWN3EyeeARnweeodUDsV3XFuzPk7;
Date: Tue, 28 Jul 2009 09:31:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David John <davidjon@xenontk.org>
Cc: torvalds@linux-foundation.org, elendil@planet.nl,
       linux-kernel@vger.kernel.org, yinghai@kernel.org
Subject: Re: [PATCH v2] Remove Spurious PnP Memory Reserved Warning
Message-ID: <20090728093137.52575d8c@jbarnes-g45>
In-Reply-To: <1248753983-4334-1-BlackWidow-davidjon@xenontk.org>
References: <1248505976-4952-1-BlackWidow-davidjon@xenontk.org>
	<1248753983-4334-1-BlackWidow-davidjon@xenontk.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 09:36:23 +0530
David John <davidjon@xenontk.org> wrote:

> Remove unnecessary complaints by the PnP sub-system about memory
> ranges being reserved.
> 
> Signed-off-by: David John <davidjon@xenontk.org>
> 
> diff --git a/drivers/pnp/system.c b/drivers/pnp/system.c
> index 59b9092..84ee297 100644
> --- a/drivers/pnp/system.c
> +++ b/drivers/pnp/system.c
> @@ -48,10 +48,11 @@ static void reserve_range(struct pnp_dev *dev,
> resource_size_t start,
>  	 * example do reserve stuff they know about too, so we may
> well
>  	 * have double reservations.
>  	 */
> -	dev_info(&dev->dev, "%s range 0x%llx-0x%llx %s reserved\n",
> -		port ? "ioport" : "iomem",
> -		(unsigned long long) start, (unsigned long long) end,
> -		res ? "has been" : "could not be");
> +	if (res) {
> +		dev_info(&dev->dev, "%s range 0x%llx-0x%llx has been
> "
> +			 "reserved\n",	port ? "ioport" :
> "iomem",
> +			(unsigned long long) start, (unsigned long
> long) end);
> +	}
>  }
>  
>  static void reserve_resources_of_dev(struct pnp_dev *dev)

I'm inclined to keep the message, since it's just a dev_info and does
provide interesting info sometimes.  So unless Linus wants to kill
it...

Jesse

-- 
Jesse Barnes, Intel Open Source Technology Center

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763527AbYB1UF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763527AbYB1UF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 15:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYB1UFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 15:05:48 -0500
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:62120 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751443AbYB1UFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 15:05:46 -0500
Date: Thu, 28 Feb 2008 21:05:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] i2c-amd756.c: fix off-by-one
Message-ID: <20080228210542.1c774c28@hyperion.delvare>
In-Reply-To: <20080227212108.GR29269@cs181133002.pp.htv.fi>
References: <20080227212108.GR29269@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Wed, 27 Feb 2008 23:21:09 +0200, Adrian Bunk wrote:
> This patch fixes an off-by-one error spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> f9829dd0d7dad9cbc08da3fceb105478e85c4137 foobar
> diff --git a/drivers/i2c/busses/i2c-amd756.c b/drivers/i2c/busses/i2c-amd756.c
> index 573abe4..2fa4318 100644
> --- a/drivers/i2c/busses/i2c-amd756.c
> +++ b/drivers/i2c/busses/i2c-amd756.c
> @@ -335,7 +335,7 @@ static int __devinit amd756_probe(struct pci_dev *pdev,
>  	u8 temp;
>  	
>  	/* driver_data might come from user-space, so check it */
> -	if (id->driver_data > ARRAY_SIZE(chipname))
> +	if (id->driver_data >= ARRAY_SIZE(chipname))
>  		return -EINVAL;
>  
>  	if (amd756_ioport) {
> 

Good catch, not sure how I managed to mess it up that way. Patch
applied, thank you.

-- 
Jean Delvare

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab0BEAc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 19:32:57 -0500
Received: from khc.piap.pl ([195.187.100.11]:38425 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab0BEAc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 19:32:56 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Josh Holland <jrh@joshh.co.uk>
Cc: gregkh@suse.de, alan@linux.intel.com, andre.goddard@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rar: fixed up rar_driver.{h,c}
References: <1265318585-24236-1-git-send-email-jrh@joshh.co.uk>
Date: Fri, 05 Feb 2010 01:32:52 +0100
In-Reply-To: <1265318585-24236-1-git-send-email-jrh@joshh.co.uk> (Josh
	Holland's message of "Thu, 4 Feb 2010 21:23:05 +0000")
Message-ID: <m3eil0o72j.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Holland <jrh@joshh.co.uk> writes:

> This is a patch to the rar_driver.c and rar_driver.h files to remove
> style issues found by the checkpatch.pl script.
>
> +++ b/drivers/staging/rar/rar_driver.c
> @@ -68,7 +68,8 @@ static void __exit rar_exit_handler(void);
>  /*
>    function that is activated on the successfull probe of the RAR device
>  */
> -static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
> +static int __devinit rar_probe(struct pci_dev *pdev,
> +	const struct pci_device_id *ent);

It's agreed such changes make it worse. The 80-column "ERROR" should be
ignored, and it will be removed from checkpatch.

> -	printk(KERN_WARNING "rar- result from send ctl register is %x\n"
> -	  ,result);
> +	printk(KERN_WARNING "rar- result from send ctl register is %x\n",
> +			result);

Also, here (and then) - I'd just make it a single line if you're changing
it. I'd be far from "unwrapping" all code across the kernel, though
(without otherwise changing the lines in question).

> +		if (memrar_get_rar_addr(pdev, (*i).low, &(rar_addr[n].low))
> +			|| memrar_get_rar_addr(pdev, (*i).high,
> +			   &(rar_addr[n].high))) {
> +			result = -1;
> +			break;
> +		}

Isn't the following a bit more readable?

+		if (memrar_get_rar_addr(pdev, i->low, &rar_addr[n].low) ||
+		    memrar_get_rar_addr(pdev, i->high, &rar_addr[n].high)) {
+			result = -1;
+			break;
+		}

It doesn't make sense to split the printk, at least every single output
line printed shouldn't be broken into pieces (but perhaps one single
line for the whole printk() is best).
Also I like the post-increments (z++) more, but maybe it's just me.

> +		size_t z;
> +		for (z = 0; z != MRST_NUM_RAR; ++z) {
> +			printk(KERN_WARNING "rar - "
> +			"BRAR[%Zd] physical address low\n"
> +			"\tlow:  0x%08x\n"
> +			"\thigh: 0x%08x\n",
> +			z,
> +			rar_addr[z].low,
> +			rar_addr[z].high);


> -#define DEBUG_PRINT_0(DEBUG_LEVEL , info) \
> -do \
> -{ \
> -  if(DEBUG_LEVEL) \
> -  { \
> -    printk(KERN_WARNING info); \
> -  } \
> -}while(0)
> +#define DEBUG_PRINT_0(DEBUG_LEVEL, info) \
> +do { \
> +	if (DEBUG_LEVEL) \
> +		printk(KERN_WARNING info); \
> +} while (0)

Also I think moving these backslashes to the right of the macro code is
preferred, isn't it?

Just my 0.01$CURRENCY as usual :-)
-- 
Krzysztof Halasa

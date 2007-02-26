Return-Path: <linux-kernel-owner+w=401wt.eu-S1030370AbXBZRow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030370AbXBZRow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030367AbXBZRov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:44:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58936
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030366AbXBZRov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:44:51 -0500
Date: Mon, 26 Feb 2007 09:44:50 -0800 (PST)
Message-Id: <20070226.094450.39157931.davem@davemloft.net>
To: dmonakhov@openvz.org
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 3/3] SPARC: Handle request_irq() failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <87y7mkq4so.fsf@sw.ru>
References: <87y7mkq4so.fsf@sw.ru>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Monakhov Dmitriy <dmonakhov@openvz.org>
Date: Mon, 26 Feb 2007 19:09:27 +0300

> Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
 ...
> @@ -389,7 +390,12 @@ static int __init ts102_uctrl_init(void)
>  	if(!driver->irq) 
>  		driver->irq = tmp_irq[0].pri;
>  
> -	request_irq(driver->irq, uctrl_interrupt, 0, "uctrl", driver);
> +	err = request_irq(driver->irq, uctrl_interrupt, 0, "uctrl", driver);
> +	if (err) {
> +		printk(KERN_ERR "%s: unable to request irq  %d\n",
> +				__FUNCTION__, driver->irq);
> +		return -EBUSY;
> +	}
>  

Why not return the error code that request_irq() gave us?

That's how I'll fix this bug.

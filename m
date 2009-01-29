Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbZA2PgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbZA2PgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758338AbZA2PfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:35:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:48910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737AbZA2PfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:35:22 -0500
Date: Thu, 29 Jan 2009 07:29:38 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: tom.leiming@gmail.com
Cc: kay.sievers@vrfy.org, greg@kroah.com, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done
Message-ID: <20090129072938.2761a6ed@infradead.org>
In-Reply-To: <1233242110-5422-1-git-send-email-tom.leiming@gmail.com>
References: <1233242110-5422-1-git-send-email-tom.leiming@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -396,9 +396,9 @@ void __init prepare_namespace(void)
>  	if ((ROOT_DEV == 0) && root_wait) {
>  		printk(KERN_INFO "Waiting for root device %s...\n",
>  			saved_root_name);
> -		while (driver_probe_done() != 0 ||
> -			(ROOT_DEV = name_to_dev_t(saved_root_name))
> == 0)
> -			msleep(100);
> +		ROOT_DEV = name_to_dev_t(saved_root_name);
> +		if (ROOT_DEV)
> +			driver_probe_wait_done();
>  	}
>  

Hi,

another comment:

this is not equivalent

you turned "wait until all probing is done OR until the device exists"
into "wait until all probing is done"... which might be several seconds
longer!

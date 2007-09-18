Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbXIRP7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbXIRP7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbXIRP7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:59:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:58538 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbXIRP7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BYVukvZCnXDAMXR7psQf3ic2/Il6jW5CMU54+k4BJtf/foI9IuPhsIUOZ3jLa7KTTbkXP+kGIIIlU9aBd+o5K4ux1lXvrpEdKqoMt0rqz5CkmyDmE05XUC1lIwKsYHfwgbp2l+15NViBbPhvBllvzycfOPZkM1Yzm0ziZ1nBwrs=
Message-ID: <d120d5000709180859r48f0d123h339884dcf481f001@mail.gmail.com>
Date: Tue, 18 Sep 2007 11:59:28 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Anti Sullin" <anti.sullin@artecdesign.ee>
Subject: Re: [PATCH 1/2] gpio_keys: add gpio_to_irq return code check
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       david-b@pacbell.net
In-Reply-To: <46EFF22A.9010509@artecdesign.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46EFF22A.9010509@artecdesign.ee>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anti,

On 9/18/07, Anti Sullin <anti.sullin@artecdesign.ee> wrote:
> As David Brownell pointed out when reviewing my suspend patch to
> gpio_keys, the original gpio_keys driver does not check gpio_to_irq
> return code.
>
...
> -               set_irq_type(irq, IRQ_TYPE_EDGE_BOTH);
> -               error = request_irq(irq, gpio_keys_isr, IRQF_SAMPLE_RANDOM,
> -                                    button->desc ? button->desc : "gpio_keys",
> -                                    pdev);
> +               if (irq < 0)

What would be the value of error variable (that we use as a return value) here?

> +                       goto fail;
> +

-- 
Dmitry

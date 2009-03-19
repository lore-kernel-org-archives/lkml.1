Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbZCSHYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbZCSHYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 03:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZCSHYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:24:06 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:45898 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbZCSHYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:24:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=hd8UF3wGRoaeowPby6g+TQYPlD7etmJm7LWZoJvFYNe22MmhHEw0ThARJmRkpNJZA/
         MGekF1/GQp5W9FyJBQ5aSpHsWZfYBv4TxQAsHSlQr2evyQ7DgDOfITqPepmiaeP8kpdR
         qni1JqjVZH2h5pBFXt2jpfXnOzWCOG143nDEY=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Question about usage of RCU in the input layer
Date: Thu, 19 Mar 2009 00:23:56 -0700
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8; KDE/4.2.1; x86_64; ; )
Cc: linux-input@vger.kernel.org, dipankar@in.ibm.com,
       linux-kernel@vger.kernel.org
References: <20090318215812.15496a86@infradead.org>
In-Reply-To: <20090318215812.15496a86@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903190023.56929.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Wednesday 18 March 2009 21:58:12 Arjan van de Ven wrote:
> Hi,
>
> the input layer does a "synchronize_rcu()" after a list_add_tail_rcu(),
> which is costing me 1 second of boot time.....
> And based on my understanding of the RCU concept, you only need to
> synchronize on delete, not on addition... so I think the synchronize is
> entirely redundant here...


It is there to guarantee that once we registered the handle all
subsequent input events will be delivered through it.
 
>
> Can I have my second of boot time back please ?
>

Not like this I'm afraid but I will see what I can do.

>
>
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 1730d73..d69ec56 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -1544,7 +1544,6 @@ int input_register_handle(struct input_handle
> *handle) return error;
>  	list_add_tail_rcu(&handle->d_node, &dev->h_list);
>  	mutex_unlock(&dev->mutex);
> -	synchronize_rcu();
>
>  	/*
>  	 * Since we are supposed to be called from ->connect()

-- 
Dmitry

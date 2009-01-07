Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZAGJNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZAGJNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZAGJM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:12:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:31534 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZAGJMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:12:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wnHj2eZyTVdNs4eMm5iznl+jeERZlmK+v5qaE2jFTdEqd0F0fOpN6Z/9qKMXcTISqp
         4BiNsRo9r+r1yyJfMSJOpGastb34iYoMsxQjMbNgP/YQRvJcBQ8Pi6Ckq5QcQHkcoWhs
         ClUjE7enuu1aSyg4NKWax39nW5U1LpKocPJ7Y=
Message-ID: <36ca99e90901070112q6ecbb6ev5b8eafb58361674d@mail.gmail.com>
Date: Wed, 7 Jan 2009 10:12:52 +0100
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH 3/6] fastboot: make the libata port scan asynchronous
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20090105201204.2c0bf9af@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090105200959.04a626ac@infradead.org>
	 <20090105201204.2c0bf9af@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 6, 2009 at 05:12, Arjan van de Ven <arjan@infradead.org> wrote:
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index fecca42..fe2c208 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -56,6 +56,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/scatterlist.h>
>  #include <linux/io.h>
> +#include <linux/async.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_host.h>
> @@ -5909,6 +5910,48 @@ void ata_host_init(struct ata_host *host, struct device *dev,
>        host->ops = ops;
>  }
>
> +
> +void async_port_probe(void *data, async_cookie_t cookie)
static?

Bert

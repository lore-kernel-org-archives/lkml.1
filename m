Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbYATAXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbYATAXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 19:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbYATAXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 19:23:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:19046 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbYATAXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 19:23:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SGrwSrglKHFpevd3wFOYgvTBYiio24P9dXrXLPKtOwDlRl6d09ngDi51hhR/ePRse4Lb9jS93N1Wzp7cQxdQkGFm1lUf2efaW+p06JzqlQoq+yF6cXOhrWHV1etXigdg4SwAu05/6XICmrV9rpUXYRgnBt8Yygh1KLoFfqieohE=
Message-ID: <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>
Date: Sun, 20 Jan 2008 02:23:13 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: trenn@suse.de
Subject: Re: [PATCH] Allocate pnp resources dynamically via krealloc
Cc: linux-acpi@vger.kernel.org, "Len Brown" <lenb@kernel.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Rene Herman" <rene.herman@keyaccess.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1200772810.3708.42.camel@queen>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200772810.3708.42.camel@queen>
X-Google-Sender-Auth: e2c208d6e86f2b06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Jan 19, 2008 10:00 PM, Thomas Renninger <trenn@suse.de> wrote:
> +static int pnp_alloc_port(struct pnp_resource_table *res)
> +{

[snip]

> +       res->port_resource = krealloc(res->port_resource,
> +             (sizeof(struct resource) * res->allocated_ports)
> +             + (sizeof(struct resource) * PNP_ALLOC_PORT), GFP_KERNEL);
> +
> +       if (!res->port_resource)
> +               return -ENOMEM;

When krealloc() returns NULL, there wasn't enough memory to fit the
new size but the original memory region remains unchanged. Therefore
you must not unconditionally overwrite the res->port_resource with the
return value of krealloc(); otherwise you might leak memory.

                Pekka

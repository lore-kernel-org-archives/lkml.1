Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbYLLInA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbYLLInA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 03:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbYLLImv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 03:42:51 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:63369 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYLLImu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:42:50 -0500
Date: Fri, 12 Dec 2008 09:42:46 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Mark McLoughlin <markmc@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/4] driver core: add root_device_register()
Message-ID: <20081212094246.5692d0ca@gondolin>
In-Reply-To: <1229019807.7968.87.camel@blaa>
References: <1229012203.7968.79.camel@blaa>
	<1229012216-4211-1-git-send-email-markmc@redhat.com>
	<20081211175604.511fc6ae@gondolin>
	<1229019807.7968.87.camel@blaa>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 18:23:27 +0000,
Mark McLoughlin <markmc@redhat.com> wrote:

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 8c2cc26..20e5825 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1196,6 +1196,93 @@ EXPORT_SYMBOL_GPL(put_device);
>  EXPORT_SYMBOL_GPL(device_create_file);
>  EXPORT_SYMBOL_GPL(device_remove_file);
> 
> +struct root_device
> +{
> +	struct device dev;
> +	struct module *owner;
> +};
> +
> +static void root_device_release(struct device *dev)
> +{

You need to get the root device here and free that.

> +	kfree(dev);
> +}

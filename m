Return-Path: <linux-kernel-owner+w=401wt.eu-S934318AbXGMFte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318AbXGMFte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbXGMFtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:49:22 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:38776 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbXGMFtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:49:21 -0400
Date: Fri, 13 Jul 2007 07:48:06 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       rientjes@google.com, Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH] try parent numa_node at first before using default
Message-ID: <20070713074806.6a641528@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <200707121059.54320.yinghai.lu@sun.com>
References: <200707101641.17672.yinghai.lu@sun.com>
	<469610D4.70009@s5r6.in-berlin.de>
	<20070712172310.4d662e1f@gondolin.boeblingen.de.ibm.com>
	<200707121059.54320.yinghai.lu@sun.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 10:59:53 -0700,
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> @@ -1285,8 +1290,11 @@ int device_move(struct device *dev, struct device *new_parent)
>  	dev->parent = new_parent;
>  	if (old_parent)
>  		klist_remove(&dev->knode_parent);
> -	if (new_parent)
> +	if (new_parent) {
>  		klist_add_tail(&dev->knode_parent, &new_parent->klist_children);
> +		set_dev_node(dev, dev_to_node(new_parent));
> +	}
> +
>  	if (!dev->class)
>  		goto out_put;
>  	error = device_move_class_links(dev, old_parent, new_parent);

You're not correctly undoing the changes if the last function fails.

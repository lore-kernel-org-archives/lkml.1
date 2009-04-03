Return-Path: <linux-kernel-owner+w=401wt.eu-S1762216AbZDCKEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762216AbZDCKEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759870AbZDCKEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:04:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:55529 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761170AbZDCKE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:04:29 -0400
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
From: David Woodhouse <dwmw2@infradead.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <200903260042.42091.david-b@pacbell.net>
References: <200903260042.42091.david-b@pacbell.net>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 11:04:22 +0100
Message-Id: <1238753062.3711.109.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-26 at 00:42 -0700, David Brownell wrote:
> 
> @@ -343,6 +343,11 @@ static struct mtd_part *add_one_partitio
>         slave->mtd.name = part->name;
>         slave->mtd.owner = master->owner;
>  
> +       /* NOTE:  we don't arrange MTDs as a tree; it'd be error-prone
> +        * to have the same data be in two different partitions.
> +        */
> +       slave->mtd.dev.parent = master->dev.parent;

Can you elaborate on that? I think we _do_ want to arrange partitions as
sub-devices of the master, don't we? And I'd rather not change the way
they appear at a later date; I'd prefer them to be that way from the
beginning.

>         slave->mtd.read = part_read;
>         slave->mtd.write = part_write;
>  
> @@ -493,7 +498,9 @@ out_register:
>   * This function, given a master MTD object and a partition table, creates
>   * and registers slave MTD objects which are bound to the master according to
>   * the partition definitions.
> - * (Q: should we register the master MTD object as well?)
> + *
> + * We don't register the master, or expect the caller to have done so,
> + * for reasons of data integrity.
>   */

Again, can you elaborate?

A lot of devices do just that. Where you have a partition table of some
kind that's actually stored on the flash, that might be the only way to
access it.

I really don't like the way our partitioning works at the moment.

-- 
dwmw2


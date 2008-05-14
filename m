Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbYENG6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbYENG6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYENG5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:57:50 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:57899 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYENG5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:57:49 -0400
Date: Wed, 14 May 2008 08:47:08 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OSS trident: switch from ->write_proc
Message-ID: <20080514054707.GB6682@il.ibm.com>
References: <20080513210544.GB23977@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513210544.GB23977@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Alexey, some comments below. This patch is a step in the right
direction but I'm afraid it's currently broken.

On Wed, May 14, 2008 at 01:05:44AM +0400, Alexey Dobriyan wrote:

> @@ -4441,11 +4446,8 @@ trident_probe(struct pci_dev *pci_dev, const struct pci_device_id *pci_id)
>  		/* ALi SPDIF OUT function */
>  		if (card->revision == ALI_5451_V02) {
>  			ali_setup_spdif_out(card, ALI_PCM_TO_SPDIF_OUT);
> -			res = create_proc_entry("ALi5451", 0, NULL);
> -			if (res) {
> -				res->write_proc = ali_write_proc;
> -				res->data = card;
> -			}
> +			proc_create_data("ALi5451", 0, NULL,
> +					 &ali_proc_fops, card);
>  		}
>  
>  		/* Add H/W Volume Control By Matt Wu Jul. 06, 2001 */

This is not enough--we need to also remove the proc_entry if
trident_probe() fails (see label `out_proc_fs'), which will require
checking if proc_create_data() succeeded. Please send an updated patch
or let me know and I'll take care of it.

Also, I no longer have working trident hardware---if someone else does
and can test this, please let me know. Otherwise we can should
probably go ahead and remove this old OSS driver.

Cheers,
Muli

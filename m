Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZKLWwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZKLWwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbZKLWwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:52:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754802AbZKLWwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:52:50 -0500
Date: Thu, 12 Nov 2009 14:52:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com
Subject: Re: [PATCH 13/17] hpsa: Retry driver initiated commands on unit
 attention
Message-Id: <20091112145248.35c76f52.akpm@linux-foundation.org>
In-Reply-To: <20091111165129.17754.71091.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
	<20091111165129.17754.71091.stgit@beardog.cce.hp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 10:51:29 -0600
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> +static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
> +	struct CommandList *c, int data_direction)
> +{
> +	int retry_count = 0;
> +
> +	do {
> +		memset(c->err_info, 0, sizeof(c->err_info));
> +		hpsa_scsi_do_simple_cmd_core(h, c);
> +		retry_count++;
> +	} while (check_for_unit_attention(h, c) && retry_count <= 3);
> +	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
> +}

If this times out, no indication of the error is returned to the caller
and no message is displayed to the operator.

Doesn't seem very robust?

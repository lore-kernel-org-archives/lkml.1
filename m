Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbYCLX21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbYCLX21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYCLX2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:28:19 -0400
Received: from ozlabs.org ([203.10.76.45]:38583 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYCLX2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:28:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: Re: [patch 3/6] Guest page hinting: mlocked pages.
Date: Thu, 13 Mar 2008 10:27:28 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@osdl.org, nickpiggin@yahoo.com.au, frankeh@watson.ibm.com,
       hugh@veritas.com
References: <20080312132132.520833247@de.ibm.com> <20080312132703.689828503@de.ibm.com>
In-Reply-To: <20080312132703.689828503@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131027.29378.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 00:21:35 Martin Schwidefsky wrote:
> --- linux-2.6.orig/include/linux/fs.h
> +++ linux-2.6/include/linux/fs.h
> @@ -513,6 +513,9 @@ struct address_space {
>  	spinlock_t		private_lock;	/* for use by the address_space */
>  	struct list_head	private_list;	/* ditto */
>  	struct address_space	*assoc_mapping;	/* ditto */
> +#ifdef CONFIG_PAGE_STATES
> +	unsigned int		mlocked;	/* set if VM_LOCKED vmas present */
> +#endif
>  } __attribute__((aligned(sizeof(long))));

Minor nit: I think this would be better under private_lock where it wouldn't 
consume any extra space on 64-bit.

Cheers,
Rusty.

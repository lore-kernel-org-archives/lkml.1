Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbXEMSnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbXEMSnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbXEMSnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:43:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60495 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475AbXEMSnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:43:46 -0400
Date: Sun, 13 May 2007 19:43:39 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] lguest guest feedback tidyups
Message-ID: <20070513184339.GZ4095@ftp.linux.org.uk>
References: <1178846246.23513.21.camel@localhost.localdomain> <1178846354.23513.23.camel@localhost.localdomain> <1178846490.23513.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178846490.23513.27.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 11:21:30AM +1000, Rusty Russell wrote:
>  	/* Devices are in page above top of "normal" mem. */
> -	lguest_devices = ioremap(max_pfn << PAGE_SHIFT, PAGE_SIZE);
> +	lguest_devices = (__force void*)ioremap(max_pfn<<PAGE_SHIFT,PAGE_SIZE);

Er...  What's being done here?  What are we mapping and what's going to
be accessed when we dereference that sucker?

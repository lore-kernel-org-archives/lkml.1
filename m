Return-Path: <linux-kernel-owner+w=401wt.eu-S1030682AbXCHVs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030682AbXCHVs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030683AbXCHVs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:48:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54495
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030682AbXCHVsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:48:25 -0500
Date: Thu, 08 Mar 2007 13:48:25 -0800 (PST)
Message-Id: <20070308.134825.45514445.davem@davemloft.net>
To: anton@samba.org
Cc: hpa@zytor.com, hch@infradead.org, arjan@infradead.org,
       zippel@linux-m68k.org, dmlb2000@gmail.com, linux-kernel@vger.kernel.org,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070308214236.GA4154@kryten>
References: <20070308175729.GA7054@kryten>
	<45F05040.4090602@zytor.com>
	<20070308214236.GA4154@kryten>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>
Date: Thu, 8 Mar 2007 15:42:36 -0600

> > The easiest way to fix this would be to always park the swap magic at 
> > the offset of the smallest page size in use, which is 4K.  This is 
> > analogous how the offset for the ext2/3 superblock got fixed at 1K -- 
> > for 1K blocks, it's the second block, but for larger blocks, it's part 
> > of the first block.  If we fix the offset of the swap magic at 4096 
> > minus the offset that's already there, it will always fall in the first 
> > page regardless of page size.
> 
> Yeah that makes sense. I gave it a go by creating a MIN_PAGE_SIZE
> define, and allowing an architecture to override it if required.

I might be missing something but doesn't this break every
SWAP partition that was created with something other than
MIN_PAGE_SIZE?

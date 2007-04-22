Return-Path: <linux-kernel-owner+w=401wt.eu-S1161468AbXDVQwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161468AbXDVQwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 12:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161479AbXDVQwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 12:52:11 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:42478 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161468AbXDVQwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 12:52:10 -0400
Subject: Re: [PATCH] dma_declare_coherent_memory wrong allocation
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.60.0704132000030.5919@poirot.grange>
References: <Pine.LNX.4.60.0704132000030.5919@poirot.grange>
Content-Type: text/plain
Date: Sun, 22 Apr 2007 11:52:05 -0500
Message-Id: <1177260725.4268.9.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-13 at 20:08 +0200, Guennadi Liakhovetski wrote:
> Either I've finally gone blind on this Friday 13th or... Looks like this 
> almost 3 year old function has a bug. Patch below compile-tested... in a 
> way.

No, it's a longstanding bug in the x86 implementation, thanks for
finding it.

> -	int bitmap_size = (pages + 31)/32;
> +	int bitmap_size = DIV_ROUND_UP(pages, 8);

This isn't quite right.  Bitmaps are arrays of longs, not arrays of
bytes.  The bug is forgetting that kmalloc() takes bytes ...

How about

int bitmap_size = DIV_ROUNDUP(pages, 32) * 4;

?

James



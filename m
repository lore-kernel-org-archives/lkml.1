Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbYKGUBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbYKGUBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYKGUBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:01:09 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39229 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbYKGUBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:01:08 -0500
Date: Fri, 7 Nov 2008 14:54:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: allocation failure in b43/ssb
Message-ID: <20081107195403.GD3546@tuxdriver.com>
References: <20081107190944.GA18949@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081107190944.GA18949@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 02:09:44PM -0500, Dave Jones wrote:
> We just had a report from a user who spotted a bunch of messages
> of the form below in his logs..

<snip>

> The kernel is a little old (2.6.26).
> 
> Looking at it though, I'm puzzled..
> 
> It seems we failed to allocate an order-1 allocation, even though
> we had memory available in the DMA and normal zones.
> 
> What am I missing?
> 
> Full logs at https://bugzilla.redhat.com/attachment.cgi?id=322882

Most of those traces look a little scrambled, but as best as I can
tell that call to setup_rx_descbuffer comes from dma_rx.  That means
that the call to __dev_alloc_skb is done with GFP_ATOMIC.  I don't
know if that factors into the answer to what is happening or not.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

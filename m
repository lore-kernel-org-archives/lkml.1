Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZIANbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZIANbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZIANbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:31:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35939 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbZIANb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:31:28 -0400
Date: Tue, 1 Sep 2009 14:31:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Xiao <dxiao@broadcom.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Steven Walter <stevenrwalter@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Robin Holt <holt@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       v4l2_linux <linux-media@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
	get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <20090901133110.GO19719@n2100.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com> <1251237768.8877.26.camel@david-laptop> <200908260117.27180.laurent.pinchart@ideasonboard.com> <1251307331.9535.16.camel@david-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251307331.9535.16.camel@david-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 10:22:11AM -0700, David Xiao wrote:
> Sorry for the confusion, page_address() indeed only returns kernel
> virtual address; and in order to support VIVT cache maintenance for the
> user space mappings, the dma_map_sg/dma_map_page() functions or even the
> struct scatterlist do seem to have to be modified to pass in virtual
> address, I think.

That's the wrong answer.  When DMA happens (and therefore these functions
are called) the userspace context could already have been switched away,
which means that any userspace address information is useless.

Adding support to the existing DMA API functions so they can be used for
userspace mapped pages is simply the wrong approach - most users of those
functions are not concerned with userspace mapped pages at all, and adding
that burden onto all those users is clearly sub-optimal.

The right answer?  I don't think there is one (see my previous mail.)

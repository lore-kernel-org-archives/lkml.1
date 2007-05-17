Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbXEQVDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbXEQVDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbXEQVDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:03:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56436 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbXEQVDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:03:23 -0400
Date: Thu, 17 May 2007 22:03:19 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: dedekind@infradead.org, hch@lst.de, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-ID: <20070517210319.GT4095@ftp.linux.org.uk>
References: <20070517143200.GA30850@lst.de> <1179413443.3642.49.camel@sauron> <20070517.135624.131107441.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517.135624.131107441.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 01:56:24PM -0700, David Miller wrote:
> From: Artem Bityutskiy <dedekind@infradead.org>
> Date: Thu, 17 May 2007 17:50:43 +0300
> 
> > Well, I see the good side of your change - no home-brewed media<->cpu
> > things. Fair enough and nice. But why don't you make __be32 a struct
> > (just like I do) so that compiler could complain then?
> 
> structs get passed on the stack instead of via registers, regardless
> of size, when passed as arguments on some architectures, so there is a
> terrible performance cost of doing things that way

BTW, the lack of home-grown coversions is not a benefit - it's _nice_ to
have protections against mixing be32 and ubi32, etc.  Avoiding the mess
with struct, OTOH, *is* a benefit.

So I'd rather go with independent bitwise types and conversions done by
use of be... ones + force-cast.  The rest of ubi code remain unchanged.

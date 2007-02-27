Return-Path: <linux-kernel-owner+w=401wt.eu-S1750714AbXB0UYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750714AbXB0UYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703AbXB0UYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:24:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50345 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbXB0UYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:24:43 -0500
Date: Tue, 27 Feb 2007 12:24:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udivdi3: 64 bit divide
Message-Id: <20070227122437.da27c3cd.akpm@linux-foundation.org>
In-Reply-To: <20070226173517.66bf0fec@freekitty>
References: <20070226173517.66bf0fec@freekitty>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 26 Feb 2007 17:35:17 -0800 Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> The kernel already has several implmentations and usages of 64 by 64 
> bit divide.
> 
> Although it is significantly slower, there are places that need it so
> provide one generic version using scaling, and allow existing platform
> versions to continue.

The reason we implement 64/32 via do_div() is, for better or for worse, to
make people think before they use it.  And to make it stand out, and so
that we discover places that are using it by accident, where they could use
something cheaper.

However your implementation of the presumably even more expensive 64/64
allows us to do 64/64 with a plain old "/" operator.

If the do_div() philosophy is any good then we should surely repeat it for
64/64, no?


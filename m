Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbXJVJ74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbXJVJ74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXJVJ7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:59:49 -0400
Received: from colin.muc.de ([193.149.48.1]:3809 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbXJVJ7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:59:49 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2007 05:59:48 EDT
Date: 22 Oct 2007 11:53:06 +0200
Date: Mon, 22 Oct 2007 11:53:06 +0200
From: Andi Kleen <ak@muc.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Message-ID: <20071022095306.GA43910@muc.de>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com> <46F050E8.5020206@goop.org> <20071020164721.GA6614@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020164721.GA6614@Krystal>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - Either I use a "r" constraint and let gcc produce the instructions,
>   that I need to assume to have correct size so I can align their
>   immediate values (therefore, taking the offset from the end of the
>   instruction will not help). Here, if gas changes its behavior
>   dramatically for a given immediate value size, it will break.

I wouldn't expect it to do that, but you could perhaps add a self
test somewhere to check for it.

> 
> - Second choice is to stick to a particular register, choosing the one
>   with the less side-effect, and encoding the instruction ourselves. I
>   start to think that this second solution might be safer, even though
>   we wouldn't let the compiler select the register which has the less
>   impact by itself.

Such effects caused occassional bugs in the alternative() implementation
which requires a maximum size for the replacement.

But in this case it should be safe enough to trust gas stability.

-Andi

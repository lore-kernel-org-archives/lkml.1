Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbXKNBwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbXKNBwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbXKNBwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:52:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38536
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbXKNBwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:52:08 -0500
Date: Tue, 13 Nov 2007 17:52:08 -0800 (PST)
Message-Id: <20071113.175208.168903694.davem@davemloft.net>
To: andi@firstfloor.org
Cc: clameter@sgi.com, akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <p73wssly6sr.fsf@bingen.suse.de>
References: <20071106195157.878563669@sgi.com>
	<20071113.031510.151440585.davem@davemloft.net>
	<p73wssly6sr.fsf@bingen.suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 14 Nov 2007 02:06:28 +0100

> David Miller <davem@davemloft.net> writes:
> >
> > The problem is that for the non-virtualized case this patch bloats up
> > the BSS section to be more than 8MB in size.  Sparc64 kernel images
> > cannot be more than 8MB in size total due to various boot loader and
> > firmware limitations.
> 
> I recently ran into a similar problem with x86-64 and large BSS from
> lockdep conflicting with a 16MB kdump kernel. Solution was to do
> another early allocator before bootmem and then move the tables into
> there.

Yes, I've run into similar problems with lockdep as well.
I had to build an ultra minimalized kernel to get it to
boot on my Niagara boxes.

I think I even looked at the same lockdep code, and I'd
appreciate it if you'd submit your fix for this if you
haven't already.

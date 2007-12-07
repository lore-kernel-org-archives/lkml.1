Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbXLGJw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbXLGJw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 04:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXLGJwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 04:52:18 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:58971 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbXLGJwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 04:52:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FF8UQPsSMWnItvF4u9N2yRjISGcFH8QbnDTy8t2c09+/c5tFk7AF0vo6jM/taaqwjhE9wmpFw9rdZtzYgvJLnuxZjobYiSm7qYTYBnp3ZmGRcuXpg50GCGVbpnwLjvtznhX8Q0uohA7jpq2/GL2hSoxHamRAn8LDsAizg3iR/9M=
Message-ID: <6934efce0712070152w70921c1od4ecfa15ce6270a0@mail.gmail.com>
Date: Fri, 7 Dec 2007 01:52:15 -0800
From: "Jared Hulbert" <jaredeh@gmail.com>
To: carsteno@de.ibm.com
Subject: Re: [patch] ext2: xip check fix
Cc: "Rob Landley" <rob@landley.net>, "Nick Piggin" <npiggin@suse.de>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jens Axboe" <axboe@kernel.dk>
In-Reply-To: <47590B7E.5040608@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204042628.GA26636@wotan.suse.de>
	 <20071206101848.GC25202@wotan.suse.de> <4757CDD4.5090606@de.ibm.com>
	 <200712061211.49443.rob@landley.net>
	 <6934efce0712061922j682cee55pc1d5d079465f4849@mail.gmail.com>
	 <47590B7E.5040608@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think so.  The filemap_xip.c functionality doesn't work for Flash
> > memory yet.  Flash memory doesn't have struct pages to back it up with
> > which this stuff depends on.
>
> Struct page is not the major issue. The primary problem is writing to
> the media (and I am not a flash expert at all, just relaying here):
> For some period of time, the flash memory is not usable and thus we
> need to make sure we can nuke the page table entries that we have in
> userland page tables. For that, we need a callback from the device so
> that it can ask to get its references back. Oh, and a put_xip_page
> counterpart to get_xip_page, so that the driver knows when it's safe
> to erase.

Well... That's the biggest/hardest problem, yes.  But not the first.
First we got to tackle the easy read only case, which doesn't require
any of that unpleasantness, yet which is used in a bunch of out of
tree hacks.

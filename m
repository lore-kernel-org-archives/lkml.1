Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbZCCAlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbZCCAlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:41:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZCCAku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:40:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:45171 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZCCAkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:40:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sYNN662scP4PnPhJzLtDojI4iAd5RabbIfIgHaUgJhY/YD5hTKB3b6B9NAijTKpsy4
         xThDEixjG1zLHv/FFvKM/VEIzXrQNkgupxQSRhJSAVAAxgKfgFZ/Tvd5GVD39v1Jyju9
         c3MRcnxUjqZ8IT4YFIMMevimJtYoQaRXPJKM0=
Subject: Re: [PATCH 1/2] byteorder: add load/store_{endian} API
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
In-Reply-To: <alpine.LFD.2.00.0903021632320.3111@localhost.localdomain>
References: <1236038817.5756.11.camel@brick>
	 <alpine.LFD.2.00.0903021613590.3111@localhost.localdomain>
	 <1236039944.5756.19.camel@brick>
	 <alpine.LFD.2.00.0903021632320.3111@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 16:40:45 -0800
Message-Id: <1236040845.5756.33.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 16:37 -0800, Linus Torvalds wrote:
> 
> On Mon, 2 Mar 2009, Harvey Harrison wrote:
> >
> > Although gcc (4.4) grew support for __builtin_constant_p in static 
> > inlines, older gcc's don't, so we would lose that with essentially all 
> > current compilers.
> 
> We've used __builtin_constant_p in inline functions for a long time.
> 
> Look at kmalloc() in <linux/slab_dev.h>.
> 
> I do agree that it's a "new" feature, but I don't think it's _that_ new. I 
> think it goes back to something like 3.2 rather than 4.4.
> 
> Although I also would not be surprised if this is one of those "gcc 
> version of the day" things, where some versions do it, others don't.
> 
> So it's quite possible that it depends a bit on just how many dead cats 
> you have offered, and whether you ran widdershins or turnwise around the 
> computer when you turned it on.
> 

OK, static inline it is then. Would you be opposed to an API like:

get_le16
put_le16

to match with 
get_unaligned_le16
put_unaligned_le16

And make the existing unaligned helpers typesafe?

Harvey


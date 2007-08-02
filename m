Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbXHBRYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbXHBRYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757607AbXHBRYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:24:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757248AbXHBRYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:24:42 -0400
Date: Thu, 2 Aug 2007 10:23:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [RFC PATCH] type safe allocator
In-Reply-To: <E1IGV6D-0000rM-00@dorka.pomaz.szeredi.hu>
Message-ID: <alpine.LFD.0.999.0708021019070.32351@woody.linux-foundation.org>
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
 <alpine.LFD.0.999.0708012051100.3582@woody.linux-foundation.org>
 <E1IGV6D-0000rM-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Aug 2007, Miklos Szeredi wrote:
> 
> The number of variations can be reduced to just zeroing/nonzeroing, by
> making the array length mandatory.  That's what glib does in g_new().

Quite frankly, you don't need the zeroing. That's what __GFP_ZERO does in 
the flags.

That said, I'm not at all sure that it's at all more readable to add some 
new abstraction layer and do

	struct random_struct *ptr;

	ptr = alloc_struct(random_struct, 1, GFP_KERNEL | __GFP_ZERO);

than just doing a

	ptr = kmalloc(sizeof(*ptr), GFP_KERNEL | __GFP_ZERO);

or

	ptr = kzalloc(sizeof(*ptr), GFP_KERNEL);

(and adding the zeroing variant of alloc_struct() just adds *more* 
confusing issues).

The fact is, type safety in this area is probably less important than the 
code just being readable. And have fifteen different interfaces to memory 
allocation just isn't ever going to readable - regardless of how good they 
are individually.

		Linus

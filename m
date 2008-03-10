Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbYCJSxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbYCJSxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYCJSxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:53:40 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:64341 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbYCJSxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fGi5yfEO4g10M8OVvvrRJ8gtrcghdRtbVUdT7sM7Zz2bjEHAZUz2rge8run41B7EFL/yIln4Khddg8CDN6siq49nF9lnQCUBvy6Gk5Sc+N1hVV4p/vWkpN+HOfnw6LoWIfTWXjy/vYmunQV8f2UN4tDs20xeTDbY1r+I8zH7huQ=
Message-ID: <87a5b0800803101153n614b044btfe02be2c77d11b84@mail.gmail.com>
Date: Mon, 10 Mar 2008 18:53:38 +0000
From: "Will Newton" <will.newton@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: copy_page_range() with VM_LOCKED
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0803101728470.3398@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87a5b0800803100926t1e4a1bb3t905d02d4c311d5e@mail.gmail.com>
	 <Pine.LNX.4.64.0803101728470.3398@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 5:40 PM, Hugh Dickins <hugh@veritas.com> wrote:

>  > mmap with MAP_LOCKED only promises the page will not be paged out, not
>  > that the page will never fault but I would like to get that behaviour.
>  >
>  > Would it be possible to add VM_LOCKED to the above conditional so
>  > copy_page_range would always copy VM_LOCKED vma page tables or would
>  > that be considered insane and broken?
>
>  It would be possible, but I don't think it would be justified - for
>  everybody who wants your behaviour, there'll be others who want the
>  current behaviour (and that condition reflects those cases on which
>  correctness demands we do the copy).
>
>  If you really want that, I think you'll have to patch your own kernel.
>
>  But much much better, mlock that area in your child after the fork,
>  since it isn't actually locked at present: that mlock will bring in
>  the pages - not quite as efficiently as copy_page_range would have done,
>  but as or more efficiently than the original mlock in the parent.

The reason I want to do this is to work around a silicon bug so I'd
rather keep the whole workaround in the kernel rather than hacking the
C library etc. I wasn't aware that the VM_LOCKED flag would be lost in
the child, it looks like I'll have to come up with a more creative
solution...

Thanks for taking the time to explain how this stuff fits together,

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbZCFIuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbZCFIuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 03:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZCFIup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 03:50:45 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:65339 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZCFIuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 03:50:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bw6jM4We3BPWSESO3Pst9zYJioGYrNTMDXMWRfuDeduXk3HVfTzwQqlheLV5Y3VcMc
         yRh4LwbHhhboQeP21QtE9pXCdJJ8UYqgBh5BqpJYDcJ7i8WGIfolbHKFIMCRpp0TYKQa
         WclDZuL9QnaPmw4eIeYP7FhvZdp99EypBR4XA=
Date: Fri, 6 Mar 2009 11:57:31 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] kmemdup_from_user(): introduce
Message-ID: <20090306085731.GA4225@x200.localdomain>
References: <49B0CAEC.80801@cn.fujitsu.com> <20090306082056.GB3450@x200.localdomain> <49B0DE89.9000401@cn.fujitsu.com> <20090306003900.a031a914.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306003900.a031a914.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 12:39:00AM -0800, Andrew Morton wrote:
> On Fri, 06 Mar 2009 16:27:53 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > > Let's not add wrapper for every two lines that happen to be used
> > > together.
> > > 
> > 
> > Why not if we have good reasons? And I don't think we can call this
> > "happen to" if there are 250+ of them?
> 
> The change is a good one.  If a reviewer (me) sees it then you know the
> code's all right and the review effort becomes less - all you need to check
> is that the call site is using IS_ERR/PTR_ERR and isn't testing for
> NULL.  Less code, less chance for bugs.
> 
> Plus it makes kernel text smaller.
> 
> Yes, the name is a bit cumbersome.

Some do NUL-termination afterwards and allocate "len + 1", but copy "len".
Some don't care.

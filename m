Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZEDUJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZEDUJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 16:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbZEDUJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 16:09:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:40420 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbZEDUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 16:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PFaBNYwSV2hkqKw4rRhnKr4sVi6B66c19xr9oNyz1+FmBDXBu5FXlbfbtCKmG1U2Ok
         K72OHkDGvwwPccc8pK1IRhircZ4mxCA8CZVTWb97UyZ55psNLS24xd1PoxPhhIbNFJ4w
         Dvdx34dY8G/vrwtWyv1wtV2lh5n5pg7w7a3Xs=
Date: Tue, 5 May 2009 00:09:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cl@linux.com, mingo@elte.hu, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com,
       xemul@openvz.org
Subject: Re: [PATCH -tip] mm: introduce __GFP_PANIC modifier
Message-ID: <20090504200925.GD31176@lenovo>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu> <20090504131638.GJ4173@lenovo> <alpine.DEB.1.10.0905040940490.9553@qirst.com> <20090504115335.9bc08587.akpm@linux-foundation.org> <20090504192117.GB31176@lenovo> <20090504123453.d130a6cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504123453.d130a6cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Mon, May 04, 2009 at 12:34:53PM -0700]
| On Mon, 4 May 2009 23:21:17 +0400
| Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Andrew Morton - Mon, May 04, 2009 at 11:53:35AM -0700]
| > | On Mon, 4 May 2009 09:47:45 -0400 (EDT)
| > | Christoph Lameter <cl@linux.com> wrote:
| > | 
| > | > 
| > | > 
| > | > Could you try to avoid consuming another GFP flag? __GFP_BITS_SHIFT is
| > | > used elsewhere to figure out where to put miscellanous flags into the gfp
| > | > mask. This is pretty limited right now and so the patch does work.
| > | 
| > | hm, yes, there are seven bits left.
| > | 
| > | afaict bit 3 (0x08) is unused?
| > | 
| > | Is __GFP_PANIC very useful?  I expect it will permit a very small code
| > | saving at a relatively small number of callsites, all of which are
| > | __init anyway?
| > | 
| > 
| > Actually the issue with possible NULL deref already fixed in -tip
| > tree commit 9a8709d. There was rather an idea on what will be more
| > convenient -- call for __GFP_NOFAIL or use BUG_ON on allocation
| > failure or call kmalloc with __GFP_PANIC and forget about if it could
| > fail :). Since Christoph said that it's discommended to introduce
| > new flag -- I'm fine with that.
| > 
| 
| Well.  Allowing the caller to dereference the NULL pointer is a good
| solution.  It gives us the runtime behaviour we want, and requires no
| new code at all.  Usages of this technique should be commented so that
| people don't "fix" it.
| 
| 
| An alternative to __GFP_PANIC might be:
| 
| -	foo = kmalloc(size, GFP_KERNEL);
| +	foo = panic_if_null(kmalloc(size, GFP_KERNEL));
| 
| void *panic_if_null(void *p)
| {
| 	if (unlikely(p == NULL))
| 		panic("NULL pointer panic");
| 	return p;
| }
| 

Yes, it's simple and elegant but at this point I'm not
going to bring this one -- I could be just shot :)

	-- Cyrill

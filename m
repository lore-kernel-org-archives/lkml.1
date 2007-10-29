Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbXJ2Rv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbXJ2Rv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbXJ2Rvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:51:50 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:8570 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755623AbXJ2Rvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j68J2XzIUJ1TxzQq7RZw+o4iqzJ6WhFFSOYeG5xnRBfK35NbwBxRVdmbaRt4XRNIXe2kNT3mBnrqRnjtCm4k6xk3odSDZUbkhpYC5DTHODYbb61wxlpeAj2YzcPfq6jJuilwaBLv+bBC+CAX/NHN/ymB+ntUYh1/wUFXwJG6Nzw=
Message-ID: <45a44e480710291051s7ffbb582x64ea9524c197b48a@mail.gmail.com>
Date: Mon, 29 Oct 2007 13:51:46 -0400
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: vm_ops.page_mkwrite() fails with vmalloc on 2.6.23
Cc: "Andrew Morton" <akpm@linux-foundation.org>, stefani@seibold.net,
       linux-kernel@vger.kernel.org, "David Howells" <dhowells@redhat.com>,
       linux-mm@kvack.org
In-Reply-To: <1193677302.27652.56.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193064057.16541.1.camel@matrix>
	 <20071029004002.60c7182a.akpm@linux-foundation.org>
	 <45a44e480710290117u492dbe82ra6344baf8bb1e370@mail.gmail.com>
	 <1193677302.27652.56.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2007-10-29 at 01:17 -0700, Jaya Kumar wrote:
> > An aside, I just tested that deferred IO works fine on 2.6.22.10/pxa255.
> >
> > I understood from the thread that PeterZ is looking into page_mkclean
> > changes which I guess went into 2.6.23. I'm also happy to help in any
> > way if the way we're doing fb_defio needs to change.
>
> OK, seems I can't read. Or at least, I missed a large part of the
> problem.
>
> page_mkclean() hasn't changed, it was ->page_mkwrite() that changed. And
> looking at the fb_defio code, I'm not sure I understand how its
> page_mkclean() use could ever have worked.
>
> The proposed patch [1] only fixes the issue of ->page_mkwrite() on
> vmalloc()'ed memory. Not page_mkclean(), and that has never worked from
> what I can make of it.
>
> Jaya, could you shed some light on this? I presume you had your display
> working.
>

I thought I had it working. I saw the display update after each
mmap/write sequence to the framebuffer. I need to check if there's an
munmap or anything else going on in between write sequences that would
cause it to behave like page_mkclean was working.

Is it correct to assume that page_mkclean should mark the pages
read-only so that the next write would again trigger mkwrite? Even if
the page was from a vmalloc_to_page()?

Thanks,
jaya

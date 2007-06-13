Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbXFMHjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbXFMHjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 03:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbXFMHjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 03:39:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:55638 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbXFMHjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 03:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qSjWdUQr2lTXixuXn9PtBjp54wK3rcfMQZfnugFU21fnNOB/E9ibWdXulhsdw81bjwF4MK5O1zMJIa7umrlr6BNiFdnuTyvSKG/+RKtFIcws5g5pc2vxayyeJb6yH6YV5+RQFjlbbtekWxeydWp1X98/C7Ovu5g5PXD3tuohxw0=
Message-ID: <a781481a0706130039r26e9522q98d9645809136ea7@mail.gmail.com>
Date: Wed, 13 Jun 2007 13:09:07 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: fix improper .init-type section references
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
In-Reply-To: <466FB20D.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466E6BDF.76E4.0078.0@novell.com>
	 <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com>
	 <466EB12B.76E4.0078.0@novell.com>
	 <a781481a0706120632p54ad83d0ka0a07a9fd9b276b4@mail.gmail.com>
	 <466EC08A.76E4.0078.0@novell.com>
	 <a781481a0706120709v5a2d1147m9d372a8056aeba6d@mail.gmail.com>
	 <20070612180002.GC15329@uranus.ravnborg.org>
	 <a781481a0706122018i6273cd17y61cd95e269b5c7c9@mail.gmail.com>
	 <20070613043526.GA20088@uranus.ravnborg.org>
	 <466FB20D.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/07, Jan Beulich <jbeulich@novell.com> wrote:
> >>> Sam Ravnborg <sam@ravnborg.org> 13.06.07 06:35 >>>
> >>
> >> Yup, we were only discussing possibility that modpost not complain
> >> about .init -> .exit references that will never go oops (because the arch
> >> guarantees that).
> >
> >And there are no good reasosns why the rules should be different for i386
> >and powerpc.
> >This type of special casing is always bad.
> >Think about it a little.
> >Someone writes a generic driver and test it on i386 - OK.
> >But for powerpc it result in a build failure. It would be so much better
> >to warn about this situation early.

Ok, that makes sense.

> And I didn't mean to special case it - I meant to suggest changing the semantics
> generally, which is why I gave the example of calling cleanup code (__exit)
> from error paths in startup code (__init).

i.e. don't discard anything at build time, and link the .exit.{text,
data} sections
into the kernel image for _all_ archs? (otherwise how do we avoid
special-casing/
checking for the arch in modpost and warn/not-warn about invalid/valid cases)

But then why not simply lose the __exit (and .exit.*) altogether? Because
__exit becomes redundant in the suggested changed semantics -- just mark
all the cleanup code as __init too (when it's built-in, the only
callsite for the
cleanup code would be from the startup code in .init.*, and when modular,
__init and __exit lose all relevance anyway).

Satyam

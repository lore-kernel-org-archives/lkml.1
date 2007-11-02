Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbXKBP33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbXKBP33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbXKBP3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:29:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:47671 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbXKBP3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hEhS1lHzHjWcL4gN0W6Fj0c5wSjsHPpHW/z4nuMJOGw3gL0NJTgcARwNfJ0suyNt4P2BbaxsljfB3eU5PnrpdKJ0UgIz58fENDjV0p/QY4O/Oit4afZ62hvc/yLCYDuGIjVeDuLSWKHV/pPjJBFZAsG8K2z97BuBebU9eRkq6QE=
Message-ID: <e2e108260711020829p5994f79bp48ca35a1ce84ff03@mail.gmail.com>
Date: Fri, 2 Nov 2007 16:29:13 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Andrew Haley" <aph@redhat.com>
Subject: Re: Is gcc thread-unsafe?
Cc: "David Schwartz" <davids@webmaster.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Tomash Brechko" <tomash.brechko@gmail.com>
In-Reply-To: <18215.1394.294830.944162@zebedee.pink>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18210.2314.57767.962503@zebedee.pink>
	 <MDEHLPKNGKAHNMBLJOLKCELIHMAC.davids@webmaster.com>
	 <18215.1394.294830.944162@zebedee.pink>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/07, Andrew Haley <aph@redhat.com> wrote:
> David Schwartz writes:
> >
> > Can we get some kind of consensus that 'optimizations' that add
> > writes to any object that the programmer might have taken the
> > address of are invalid on any platform that supports memory
> > protection?
>
> That's what the proposed standard language says, kinda-sorta.  There's
> an informal description at
> http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2338.html.

There is other important information in the cited text. A.o. it is
explained that register promotion of potentially shared variables can
introduce data races. Or: register promotion can introduce bugs in
multithreaded software when compiled with optimization enabled. Are
there any register promotion transformations implemented in gcc that
can introduce data races in multithreaded software ? This is very
important information both for kernel developers and for developers of
multithreaded userspace applications.

Another conclusion from the cited text is that in contrast with what
was stated before on the gcc mailing list, it is not required to
declare thread-shared variables volatile if that thread-shared data is
consistently protected by calls to locking functions.

Bart Van Assche.

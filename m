Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbXFKXWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbXFKXWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbXFKXWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:22:05 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:46233 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbXFKXWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:22:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W5My/r0+IGe0o3Zqkwkxstlees7sC+Y6UmDuui70KaS3qyc9la07yCkFRoyrrKBUxyc3O8Pne81T5p2FDuRnOrfBTywkjpqgfIb87E5c/7+FQNEtAyCqLQsTHplRN/Fkgup+RNUs//RmB/97/dGOV5sBUy6zxfYd2k5UTZRtl7E=
Message-ID: <8bd0f97a0706111622g494681a1u15354e799fd1b611@mail.gmail.com>
Date: Mon, 11 Jun 2007 19:22:02 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bernd Schmidt" <bernds_cb1@t-online.de>
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
Cc: "Matt Mackall" <mpm@selenic.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Howells" <dhowells@redhat.com>,
       "Wu, Bryan" <Bryan.Wu@analog.com>, "Greg Ungerer" <gerg@snapgear.com>
In-Reply-To: <466DD4E1.4030305@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46695F6D.5050600@t-online.de> <20070609191010.GB11166@waste.org>
	 <8bd0f97a0706111509s161c6287pdce612946194d87@mail.gmail.com>
	 <466DD4E1.4030305@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Bernd Schmidt <bernds_cb1@t-online.de> wrote:
> Mike Frysinger wrote:
> > On 6/9/07, Matt Mackall <mpm@selenic.com> wrote:
> >> On Fri, Jun 08, 2007 at 03:53:49PM +0200, Bernd Schmidt wrote:
> >> > 2. It is no longer possible to get blocks smaller than a page through
> >> >    mmap.  This behaviour was used by simplemalloc, which is an insane
> >> >    way of implementing malloc on nommu systems and hopefully not used
> >> >    by anyone anymore.
> >>
> >> That's worrisome. Breaking existing apps/libraries seems like a bad
> >> idea.
> >
> > it isnt breaking anything ... simplemalloc() will continue to execute
> > in newer kernels
>
> While that's true, it'll have an even bigger memory overhead than it
> already does (simplemalloc, by trapping into the kernel and creating
> vm_area/vm_list structures for every malloc call, has huge overheads in
> both time and space).

yes, it does increase the runtime overhead, but the simplemalloc
implementation is already tagged as crappy, so i dont think it's that
big of a deal ... especially in light of all of the advantages the
other malloc implementation gets us nommu peeps
-mike

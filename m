Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbXGPWzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbXGPWzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXGPWyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:54:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:16949 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbXGPWyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=spHQmViPiW9sMpkHknkkxnzpMKETLpkmYyywo5EIOHdX3nTbdQWjrD8VZxRPVV96CdyT7X6dV9ThWpT78NbHdYTOvNuSIxDElgpulf/HncKh7PmTxPFisafdJFbSpYH53wFk3xtq1HHpiEnKQKkCbeHoAWxA3g3EjFfWDSy4enk=
Message-ID: <9a8748490707161554j1fa7625fq1f1cb7e6aa359715@mail.gmail.com>
Date: Tue, 17 Jul 2007 00:54:46 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Rene Herman" <rene.herman@gmail.com>, "Bodo Eggert" <7eggert@gmx.de>,
       "Matt Mackall" <mpm@selenic.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8FO1e-2jW-35@gated-at.bofh.it> <8Gj55-hJ-5@gated-at.bofh.it>
	 <8GkNo-2Vb-1@gated-at.bofh.it> <8GtnN-7TG-23@gated-at.bofh.it>
	 <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz>
	 <469A5D7C.5010904@gmail.com>
	 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	 <469BF104.1040703@gmail.com>
	 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> On 7/16/07, Rene Herman <rene.herman@gmail.com> wrote:
> > Seeing as how single-page stacks are much easier on the VM so that creating
> > those zillion threads should also be faster, at _some_ percentage we get to
> > say "and now to hell with the rest".
>
> This is the core dispute here. Stated differently, I hope you never
> design a bridge that I have to drive over.
>
> Correctness first, optimization second. Introducing random and
> difficult to trace crashes upon an unsuspecting audience of sysadmins
> and users is not a viable option.
>
> If at some point one of the pro-4k stacks crowd can prove that all
> code paths are safe, or introduce another viable alternative (such as
> Matt's idea for extending the stack dynamically), then removing the 8k
> stacks option makes sense.
>

Please note that I was not trying to remove the 8K stack option right
now - heck, I didn't even add anything to feature-removal-schedule.txt
- all I wanted to accomplish with the patch that started this threas
was;  a) indicate that the 4K option is no longer a debug thing  and
b) make 4K stacks the default option in vanilla kernel.org kernels as
a gentle nudge towards getting people to start fixing the code paths
that are not 4K stack safe.
Distros that currently use 8K stacks can continue to do so just fine,
individuals compiling their own kernel.org kernels can as well and
people using oldconfig wouldn't get any change, only people
configuring a new kernel.org kernel from scratch would see a change.
It was mostly meant as a hint that we want to move in the 4K stack
direction over time...
In the future (perhaps far future) when all 4K unsafe codepaths are
believed to have been fixed an entry could be made in
feature-removal-schedule.txt stating that the 8K option would go away
in 6, 12 or whatever, months.   That was my intention with the patch I
posted, I never intended to rip out 8K stacks anytime *soon*.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

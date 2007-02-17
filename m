Return-Path: <linux-kernel-owner+w=401wt.eu-S933043AbXBQVuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbXBQVuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933044AbXBQVuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:50:40 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:41905 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043AbXBQVuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:50:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZP1IqHfpAnvE+9gWvHCHqMKy5APAJczBp4Ov+5Iqfz+X4ygzXLZRdwH4aT6LA9oGQr/jaO+UwsanRRWBe9nWKyignoF8LXG9A0PcSXs5R/ZfC0B5tKQ996HBLw/bIhfrHbBr5s/XI9af9p8PmZfleQZtEjgoK/GmWUTAkjKbZos=
Message-ID: <b14e81f00702171350p6dc93a92ncad14f172356d11e@mail.gmail.com>
Date: Sat, 17 Feb 2007 16:50:37 -0500
From: "michael chang" <thenewme91@gmail.com>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: [ck] Re: 2.6.20-ck1
Cc: "Chuck Ebbert" <cebbert@redhat.com>,
       "ck mailing list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200702180800.07393.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702162110.03355.kernel@kolivas.org>
	 <200702171417.28376.kernel@kolivas.org> <45D74D34.5020201@redhat.com>
	 <200702180800.07393.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/07, Con Kolivas <kernel@kolivas.org> wrote:
> On Sunday 18 February 2007 05:45, Chuck Ebbert wrote:
> > Con Kolivas wrote:
> > > Maintainers are far too busy off testing code for
> > > 16+ cpus, petabytes of disk storage and so on to try it for themselves.
> > > Plus they worry incessantly that my patches may harm those precious
> > > machines' performance...
> >
> > But the one I like, mm-filesize_dependant_lru_cache_add.patch,
> > has an on-off switch.
> >
> > In other words it adds an option to do things differently.
> > How could that possibly affect any workload if that option
> > isn't enabled?
>
> Swap prefetch not only has an on-off switch, you can even build your kernel
> without it entirely so it costs even less than this patch... I'm not going to
> support the argument that it might be built into the kernel and enabled
> unknowingly and _then_ cause overhead.

The patch, the way it's written now -- is the default to build with
swap-prefetch, or build without by default? If the former, maybe it
would be more accepted if the latter was the default. (Of course, that
defeats the point for desktop users who add the patch and then wonder
why it doesn't work, but... *shrugs*)

> Oh and this patch depends on some of the code from the swap prefetch patch
> too. I guess since they're so suspicious of swap prefetch the swap prefetch
> patch can be ripped apart for the portions of code required to make this
> patch work.

While I'm all for putting Con's patches into mainline, I'm worried
about what happens if you rip swap prefetch apart and (if the
unthinkable happens) somebody accidentally omits something or worse.
Then mainline would have even more reason to be suspicious of code
from you, Con. Unless you already ripped the swap prefetch patch into
the parts that mm-filesize_dependant_lru_cache_add.patch depend on and
the parts it doesn't, and check it's "sane" to use them
independently...

(I'd be WAY more suspicious of having "half" of swap prefetch than
having all of it. I hope that most of mainline agrees with me, but I
have a sneaking suspicion they don't.)

In any case, this "ripping"... would it make the reverse happen? i.e.
swap prefetch being dependent on
mm-filesize_dependant_lru_cache_add.patch instead?

-- 
~Mike
 - Just the crazy copy cat.

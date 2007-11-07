Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbXKGGuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbXKGGuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbXKGGuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:50:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:13704 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbXKGGue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:50:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YUv+Nimjp174BsKFqfwqeQtPJ0woEsQW81hzd2/c8etEYb+ZemZojCi8eQSCMBMnYmLPKaNUZbZe+fbTPo/JW5tteHSMZ7pTG/m8OL4fjhiEYinz6p0n2G+Qxsxr8PUFU021a2B14cpbt58F/FGtvNLOqRSBZfwNDmf3eAzRQPI=
Message-ID: <3877989d0711062250g44e5d0ecq1e4b893fa2bad94a@mail.gmail.com>
Date: Wed, 7 Nov 2007 14:50:33 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Simon Horman" <horms@verge.net.au>
Subject: Re: [PATCH] fix typo in per_cpu_offset
Cc: "David Miller" <davem@davemloft.net>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <20071107064429.GC3571@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0710230015x1640388aod98cae2fa3fc82c2@mail.gmail.com>
	 <20071030071513.GE5361@verge.net.au>
	 <20071030.003622.265888160.davem@davemloft.net>
	 <20071030085054.GE10635@verge.net.au>
	 <20071107064429.GC3571@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NAK for now.

I'm trying to add lockdep , so please don't delete it until it could
be proved really useless...
Please don't hurry...

On 11/7/07, Simon Horman <horms@verge.net.au> wrote:
> On Tue, Oct 30, 2007 at 05:50:56PM +0900, Simon Horman wrote:
> > On Tue, Oct 30, 2007 at 12:36:22AM -0700, David Miller wrote:
> > > From: Simon Horman <horms@verge.net.au>
> > > Date: Tue, 30 Oct 2007 16:15:13 +0900
> > >
> > > > Though curiuously with my config nothing uses per_cpu_offset()
> > > > (I added a bogus call to produce an error.) Is it actually
> > > > used on ia64?
> > >
> > > It is unused, and in that regard should probably be deleted.
> > >
> > > include/asm-generic/percpu.h defines a seemingly similarly
> > > unused per_cpu_offset() macro define as well
> >
> > It looks like they were both added by "[PATCH] lockdep: add per_cpu_offset()"
> > (a875a69f8b00a38b4f40d9632a4fc71a159f0e0d)
> >
> > Perhaps they were used at that time?
>
> I looked into this a little further:
>
> I'm pretty much convinced that the asm-ia64 version of per_cpu_offset()
> is unused as ia64 doesn't have lockdep. I will send a patch to get rid
> of it. The generic version might be used on mips, sh or arm with
> CONFIG_SMP, as these architectures have lockdep. I did managed to
> produce a compiler error on mips by removing the asm-generic version of
> per_cpu_offset().
>
> --
> Horms
>   H: http://www.vergenet.net/~horms/
>   W: http://www.valinux.co.jp/en/
>
>

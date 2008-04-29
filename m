Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYD2DB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYD2DB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYD2DBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:01:51 -0400
Received: from rv-out-0708.google.com ([209.85.198.248]:57583 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751045AbYD2DBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vJS812O8ZsXv2HXRCvvJ1OpsByEpr3O1RTQA5aN1jKfpg44TRSQ6pCBB+NJfqQVmQFyNAK42p42ypyaemQ1gFxq4qCJgSUMSu+HusBoGrWHlyRlb1GGtAUcF2ZlidRoPhXdOu2VjKeR4Iw1ulUpx2Tq91fFVWTpahevJ1v6TzaA=
Message-ID: <86802c440804282001r173339bby9e0777f41e152b70@mail.gmail.com>
Date: Mon, 28 Apr 2008 20:01:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete layout v5
Cc: "Yinghai Lu" <yhlu.kernel.send@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mika Fischer" <mika.fischer@zoopnet.de>
In-Reply-To: <20080428194200.c778029a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804281244.56938.yhlu.kernel@gmail.com>
	 <200804281316.14168.yhlu.kernel@gmail.com>
	 <200804281505.05764.yhlu.kernel@gmail.com>
	 <20080428194200.c778029a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 7:42 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 28 Apr 2008 15:05:05 -0700 Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>
>  >
>  > some BIOS like to use continus MTRR layout, and may X driver can not add
>  > WB entries for graphical cards when 4g or more RAM installed.
>  >
>  > the patch will change MTRR to discrete.
>  >
>  > mtrr_chunk_size= could be used to have smaller continuous block to hold holes.
>  > default is 256m, could be set according to size of graphics card memory.
>  >
>  > v2: fix -1 for UC checking
>  > v3: default to disable, and need use enable_mtrr_cleanup to enable this feature
>  >     skip the var state change warning.
>  >     remove next_basek in range_to_mtrr()
>  > v4: correct warning mask.
>  > v5: CONFIG_MTRR_SANITIZER
>  >
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
>
> > +#ifdef CONFIG_MTRR_SANITIZER
>  > +
>  > +#ifdef CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT
>
>  I don't think these newly-added config items should exist, sorry.  But
>  then, the changelog does't describe _why_ they exist (it should!) and I
>  probably missed it in the discusson.
>
>  Anyone who distributes a kernel will need to enable both
>  CONFIG_MTRR_SANITIZER and CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT, so the
>  config items are only useful for saving a bit of kernel text in custom
>  kernel builds.
>
>
>  > +static int enable_mtrr_cleanup __initdata = 1;
>  > +#else
>  > +static int enable_mtrr_cleanup __initdata;
>
>  The disable_mtrr_cleanup and enable_mtrr_cleanup boot options are also
>  problematic.  We really really want this stuff to all happen automatically.
>
>  What happens with this sort of thing is that people's machines misbehave
>  and I expect most of them never find out about the magic option.  They
>  give up on Linux or use a different computer or use a different distro
>  which happened to set the option the other way, etc, etc.  Some people will
>  think to do a bit of googling and might stumble across the option after a
>  while.
>
>  It's all rather user-unfriendly and we should try really hard to just make
>  things work.  Is this at all possible?

Eric or Andi said it is too risky to touch mtrr.

>
>
>  Anyway.  I think the problem which you have identified is solveable in
>  userspace, isn't it?  Read the existing mtrr settings and rewrite them in a
>  better form?  If so, we could prepare a little program which does that and
>  make the X people and distributors aware of it.  This has the significant
>  advantage that it will fix pre-2.6.26 kernels too.

sounds good.

YH

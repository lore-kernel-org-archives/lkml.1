Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbYHZWcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbYHZWcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbYHZWce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:32:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:30205 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbYHZWcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:32:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hgq99CV5Bxmq9ZQUF0I0JQRLqAtr0rI4FF4eksqOGssvyxQfL6ZXqwv2cQwOwSco3d
         Kkuxmkb4xwdJF4otgHve8Bmu4074kyw57kOwIEPnYa6B0zrakIT5nnaHCaNWO9TYoD3M
         NO/ZLmXf7bGNrZtuNgJl5bAwXdpjCE/PHvkk4=
Date: Wed, 27 Aug 2008 02:34:03 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] utrace
Message-ID: <20080826223402.GB27724@x200.localdomain>
References: <20080826220102.89635154233@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826220102.89635154233@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 03:01:02PM -0700, Roland McGrath wrote:
> utrace is a new kernel-side API for kernel modules, intended to make it
> tractable to work on novel ways to trace and debug user-mode tasks.

Finally! Familiar code! :^)

> A previous utrace prototype was in all Fedora kernels since Fedora Core 6.
> Some substantial implementation and API details in the current code are
> different from those past versions.

And some internal details still horrible and overdesigned just like at
the very beginning.

> Please look freshly at these patches.

Well, all comments on tracehook patches were ignored.

> This code cannot be enabled without CONFIG_HAVE_ARCH_TRACEHOOK and the arch
> details it indicates.  In Linus's tree as of v2.6.27-rc4, only powerpc and
> sparc64 have that support.  The x86 support is available by merging in the
> tip/x86/tracehook branch.  For working on other arch support, there are some
> more details at http://sourceware.org/systemtap/wiki/utrace/arch/HowTo and
> these are mentioned in the comments in arch/Kconfig too (in v2.6.27-rc4).
> 
> The first patch adds the utrace kernel API (if CONFIG_UTRACE=y is set).
> There is no change at all without the config option, and with it there is
> no effect on anything at all until a kernel module using the utrace API is
> loaded.  There is detailed documentation on the API in DocBook form.
> 
> The second patch adds the CONFIG_UTRACE_PTRACE option.

If config option for ptrace is fine, please name it CONFIG_PTRACE.
For one, there will be no second tracing infrastracture. For two, nobody
but one man on the planet really cares how ptrace(2) is implemented.

> When set, this makes ptrace use the utrace API as much as is necessary so
> that using both ptrace and utrace to debug the same threads at the same time
> won't become confused.  The ptrace changes are somewhat kludgey.  They're
> intended to be the simplest, non-regressing thing that suffices to enable
> hacking on new utrace modules while also doing normal ptrace-based debugging.
> The ptrace implementation can still use many more cleanups later on.

General comments:

On the good side is per-task struct operation. This is good and should
be required from any such tracing facility.

Linked list of attached tracers? I don't know.

One the bad side, where are those nice tracing modules? Where are they?

I've heard rumours utrace is needed for frysk and frysk people were
pretty damn silent on linux-kernel.

On the homepage there is module which frozes task right before coredump.
AFAICS, Al Viro mentioned that non-schedulable TASK_BROKEN should be
sufficient for this without wasting all that time that went into
ptrace(2) stabilization and fixing holes in it.

This all similar to systemtap/markers story. Big changes under promises
that now, now somebody will use our thing.


General reminder:
people who collected ptrace(2) exploits proggies, try them again.

Now to code.


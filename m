Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbZIKDAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbZIKDAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 23:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZIKDAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 23:00:38 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:38230 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbZIKDAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 23:00:37 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Sep 2009 23:00:36 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dJjCbyG6hXjgLpd/nrwmjFWHaF50qXY3+CkfcFWbi1ciQOVCzTW1rT2koAxWF7nWnz
         G51g5nag3QfGuYcGgaJyOBv1RhjnIxI6I5ZA8LOHi5EMHUj36sKqcfrlFTRAjiWTzTmC
         xwbZB5U2kiQZ7ci9sO3dibYboYRB7LZzKlf0I=
MIME-Version: 1.0
In-Reply-To: <20090909134752.f5b8c2e7.sfr@canb.auug.org.au>
References: <20090909134752.f5b8c2e7.sfr@canb.auug.org.au>
Date: Thu, 10 Sep 2009 23:00:38 -0400
Message-ID: <817ecb6f0909102000n4b3308cayd242cb329fcedde3@mail.gmail.com>
Subject: Re: linux-next: rr tree build failure
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Xuxian Jiang <jiang@cs.ncsu.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 8, 2009 at 11:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Rusty,
>
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
>
> kernel/module.c: In function 'set_section_ro_nx':
> kernel/module.c:1549: error: implicit declaration of function 'set_memory_ro'
> kernel/module.c:1560: error: implicit declaration of function 'set_memory_nx'
> kernel/module.c: In function 'unset_section_ro_nx':
> kernel/module.c:1575: error: implicit declaration of function 'set_memory_rw'
>
> Caused by commit 25306e21864c2a220d6fa2e0632425028aa9626c
> ("module:ro-nx-protection") which uses these interfaces that are only
> defined on x86 ...
>
> I have used the version of the rr tree from next-20090908 for today.

I have posted a replacement patch for that commit: "[PATCH v6] RO/NX
protection for loadable kernel modules"
Please let me know if you would rather see a short "patch patch"
rather than complete patch replacement. The fix, essentially, is to
encapsulate entire bodies of unset_section_ro_nx() and
set_section_ro_nx() inside #ifdef CONFIG_X86 ... #endif. This way
set_memory_* will be called only on x86.

Thanks.

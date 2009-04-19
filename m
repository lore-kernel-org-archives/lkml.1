Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZDSHdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZDSHdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 03:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZDSHdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 03:33:07 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:20619 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbZDSHdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 03:33:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=cB/dCl7+2AK6nwcfYyy39EHMQ/FzFYrjPB0iXD6sA6RgZCzNvAcnmv3o/7XdaGNVFv
         Wg/L/jrXPbDdUZLERIyXD4E1HnLBzp5H09NDPwdgGGAwv0tqo1l/4RWFNO501hREesrG
         INdf8CULGFOZd6xrmEEnZ2GBxfn+44DmhqugI=
Subject: Re: mips build failure
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090419172436.6d0e741a.sfr@canb.auug.org.au>
References: <20090419172436.6d0e741a.sfr@canb.auug.org.au>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Sun, 19 Apr 2009 15:32:41 +0800
Message-Id: <1240126361.3423.5.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-19 at 17:24 +1000, Stephen Rothwell wrote:
> Hi Ralf,
> 
> You probably already now about this, but our build (mips ip32_defconfig)
> of Linus' tree (commit aefe6475720bd5eb8aacbc881488f3aa65618562 "Merge
> branch 'upstream-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev") gets
> these errors (we have actually been getting these errors since 2.6.30-rc1):
> 
> In file included from arch/mips/include/asm/compat.h:7,
>                  from include/linux/compat.h:15,
>                  from arch/mips/kernel/asm-offsets.c:12:
> include/linux/seccomp.h: In function 'prctl_get_seccomp':
> include/linux/seccomp.h:30: error: 'EINVAL' undeclared (first use in this function)
> include/linux/seccomp.h:30: error: (Each undeclared identifier is reported only once
> include/linux/seccomp.h:30: error: for each function it appears in.)
> include/linux/seccomp.h: In function 'prctl_set_seccomp':
> include/linux/seccomp.h:35: error: 'EINVAL' undeclared (first use in this function)
> 

perhaps you can fix it like this:

include/linux/seccomp.h

 22 #else /* CONFIG_SECCOMP */
 23 
 24 +#include <asm-generic/errno-base.h>
 25 
 26 typedef struct { } seccomp_t;

in reality, there is a previous email sent by Ralf for it:

http://lkml.indiana.edu/hypermail/linux/kernel/0904.2/01152.html

> Bisected down to commit ac44021fccd8f1f2b267b004f23a2e8d7ef05f7b
> "kmemtrace, rcu: don't include unnecessary headers, allow kmemtrace w/
> tracepoints".
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/330240/


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZIIOch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZIIOch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbZIIOcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:32:36 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:38024 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbZIIOcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vAXsa85XUBILxvuZA6yrwigFyPNtQZaUrDx3I7jnMZwfIvCU4dvX2VPTNK2CWYuC9Y
         O3giwDg2CD4x9l0h3K16QxdCvcE5CPB5/Z0+PwVRojUEEq5LvVeqJTID5NB9NkluXtPt
         lQ5n0EzSzS5MhKwTpP23VvtA8QeZf/MspNIPw=
MIME-Version: 1.0
In-Reply-To: <20090909134752.f5b8c2e7.sfr@canb.auug.org.au>
References: <20090909134752.f5b8c2e7.sfr@canb.auug.org.au>
Date: Wed, 9 Sep 2009 10:32:38 -0400
Message-ID: <817ecb6f0909090732j6b1e097dobcb59af8147e30cf@mail.gmail.com>
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

Looks like I have made some bad assumptions. I will re-write the
original patch to be x86-only.

Sorry for breaking the build.

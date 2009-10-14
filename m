Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbZJNHoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbZJNHoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbZJNHoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:44:22 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:36520 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbZJNHoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:44:21 -0400
Date: Wed, 14 Oct 2009 09:43:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: linux-next: kbuild tree build failure
Message-ID: <20091014074344.GA6330@merkur.ravnborg.org>
References: <20091014122024.f5fa52a2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014122024.f5fa52a2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 12:20:24PM +1100, Stephen Rothwell wrote:
> Hi Sam,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> In file included from arch/x86/kernel/syscall_64.c:28:
> arch/x86/include/asm/unistd_64.h:665: error: array index in initializer exceeds array bounds
> arch/x86/include/asm/unistd_64.h:665: error: (near initialization for 'sys_call_table')
> arch/x86/include/asm/unistd_64.h:665: warning: excess elements in array initializer
> arch/x86/include/asm/unistd_64.h:665: warning: (near initialization for 'sys_call_table')
> 
> Exposed by commit a2e2725541fad72416326798c2d7fa4dafb7d337 ("net:
> Introduce recvmmsg socket syscall").  include/asm/asm-offsets.h did not
> get updated even though arch/x86/kernel/asm-offsets.s did.  Ah,
> generated/asm-offsets.h has been updated but my build tree still has the
> (generated in a previous build) include/asm/asm-offsets.h which is
> presumably found before the new arch/x86/include/asm/asm-offsets.h
> introduced by commit fe5ff47a5d79ca99ec7e3155eb19469b44905b2c ("kbuild:
> move asm-offsets.h to include/generated").
> 
> Sam, can you think of a better migration path?

I once thought of forefully removing include/asm to avoid this.
Maybe we could let "make clean" remove include/asm -
I expect this would have helped in this situation?

I'm planning to redo the serie within the next couple of weeks anyway.

	Sam

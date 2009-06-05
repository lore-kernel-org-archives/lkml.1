Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZFECge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZFECge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 22:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZFECg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 22:36:26 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:49425 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbZFECg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 22:36:26 -0400
X-Greylist: delayed 60132 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 22:36:26 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZctYY2y2mgS6fM9j8Qs756yK34Sje3+xbwrSPH2NtU+zvM0YbYITE6zTzUJrGOr2tZ
         EwTC1iU8dO6+pcMvWr0MUadd+5opBZUMQjf/fsZQHUeSPBquKctAx6Q6mcQpxB0C9NYe
         a6TMNp4dS4rieLWZXVZ3bFK1BupT6LRXWvI5o=
Date: Fri, 5 Jun 2009 10:38:35 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
Message-ID: <20090605023835.GA7933@cr0.nay.redhat.com>
References: <200906050038.n550c4Ja010907@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906050038.n550c4Ja010907@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 09:38:04AM +0900, Tetsuo Handa wrote:
>[2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
>
>"make allmodconfig" + "CONFIG_KVM=n" on 2.6.30-rc8 triggers build failure
>when built with gcc 3.3.5 .
>
># make -s
>/usr/src/all/vanilla/src/linux-2.6.30-rc8/arch/x86/Makefile:82: stack protector enabled but no compiler support
>WARNING: modpost: Found 2 section mismatch(es).
>To see full details build your kernel with:
>'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>arch/x86/mm/built-in.o(.init.text+0x43f7): In function `__change_page_attr':
>arch/x86/mm/pageattr.c:114: undefined reference to `__udivdi3'
>make: *** [.tmp_vmlinux1] Error 1
>

Probably you are compiling on i386?

Weird... 

All the types in __change_page_attr() are either 'long' or 'int', how
can gcc generate software divide for these integer operations?

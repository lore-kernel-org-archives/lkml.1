Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZLRJw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZLRJw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZLRJwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:52:54 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:59014 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZLRJww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:52:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TjZaMh59gg4SCGw5UlKBrsnYhM9onAt3pK5s2zNHLEYgWd6B0TN9njKf9D/nFLVkUf
         lookhtMQLBEUvU3zMUV8s+45kDSm0qzOSUf5ZOiiNe+gde8LU7d4AxyTuktx48hzP6sX
         Q9kJ925rrTlh1gfUpk16KfB/t/fMTVC8mEr2w=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.01.0912172037570.9874@filesrv1.baby-dragons.com>
References: <alpine.LNX.2.01.0912172037570.9874@filesrv1.baby-dragons.com>
Date: Fri, 18 Dec 2009 17:52:51 +0800
Message-ID: <2375c9f90912180152p2189aa60o96c1c0ec97c30b83@mail.gmail.com>
Subject: Re: kernel/rcutree.h:301: sorry, unimplemented: inlining failed in 
	call to 'rcu_bootup_announce': function body not available
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Linux Kernel Maillist <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 1:45 PM, Mr. James W. Laferriere
<babydr@baby-dragons.com> wrote:
>        Hello All ,
>
>  gcc -Wp,-MD,kernel/.rcutree.o.d  -nostdinc -isystem
> /usr/lib/gcc/i486-slackware-linux/3.4.6/include -Iinclude
> -I/usr/src/linux-2.6.32.1/arch/x86/include -include include/linux/autoconf.h
> -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
> -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
> -Wno-format-security -fno-delete-null-pointer-checks -O2 -m32 -msoft-float
> -mregparm=3 -freg-struct-return -mpreferred-stack-boundary=2
> -fno-unit-at-a-time -march=i686 -ffreestanding -DCONFIG_AS_CFI=1 -pipe
> -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx
> -mno-sse2 -mno-3dnow -fno-omit-frame-pointer -fno-optimize-sibling-calls -g
> -Wdeclaration-after-statement   -D"KBUILD_STR(s)=#s"
> -D"KBUILD_BASENAME=KBUILD_STR(rcutree)"
>  -D"KBUILD_MODNAME=KBUILD_STR(rcutree)" -c -o kernel/rcutree.o
> kernel/rcutree.c
> kernel/rcutree.c: In function `__rcu_init':
> kernel/rcutree.h:301: sorry, unimplemented: inlining failed in call to
> 'rcu_bootup_announce': function body not available
> kernel/rcutree.c:1740: sorry, unimplemented: called from here
> make[1]: *** [kernel/rcutree.o] Error 1
> make: *** [kernel] Error 2
>
>        There is no way ,  thru the 'make *config' methods to disable this
> broken stuff ,  So How may I get past this brokeness ?
>        And looking the posts for the 2.6.32-pre/rc the old rcu has been
> trashed completely .  So I am not able to even try using that .
>
>        Would someone please shed some light on this .  I really need the
> updates for the Fusion/mpt driver & the changes in the /md/ tree as well .

Hmm, I see the problem, but not sure how to fix it...

Paul, why do we have #include "rcutree_plugin.h" at the bottom
of rcutree.c? This looks strange for me...

How about moving it up? At least just move upper to rcu_init().

Thanks!

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZLRRIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZLRRIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZLRRII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:08:08 -0500
Received: from ns3.baby-dragons.com ([64.62.236.141]:51905 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZLRRIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:08:06 -0500
Date: Fri, 18 Dec 2009 08:07:51 -0900 (AKST)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [kernel] Re: kernel/rcutree.h:301: sorry, unimplemented: inlining
 failed in call to 'rcu_bootup_announce': function body not available
In-Reply-To: <20091218160100.GA6712@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.01.0912180803130.9874@filesrv1.baby-dragons.com>
References: <alpine.LNX.2.01.0912172037570.9874@filesrv1.baby-dragons.com> <2375c9f90912180152p2189aa60o96c1c0ec97c30b83@mail.gmail.com> <20091218160100.GA6712@linux.vnet.ibm.com>
User-Agent: Alpine 2.01 (LNX 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="566704117-345244137-1261156072=:9874"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (ns3.baby-dragons.com [64.62.236.141]); Fri, 18 Dec 2009 17:07:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--566704117-345244137-1261156072=:9874
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

 	Hello Paul (& Americo, ALL) ,

On Fri, 18 Dec 2009, Paul E. McKenney wrote:
> On Fri, Dec 18, 2009 at 05:52:51PM +0800, Américo Wang wrote:
>> On Fri, Dec 18, 2009 at 1:45 PM, Mr. James W. Laferriere
>> <babydr@baby-dragons.com> wrote:
>>>        Hello All ,
>>>
>>>  gcc -Wp,-MD,kernel/.rcutree.o.d  -nostdinc -isystem
>>> /usr/lib/gcc/i486-slackware-linux/3.4.6/include -Iinclude
>>> -I/usr/src/linux-2.6.32.1/arch/x86/include -include include/linux/autoconf.h
>>> -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
>>> -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
>>> -Wno-format-security -fno-delete-null-pointer-checks -O2 -m32 -msoft-float
>>> -mregparm=3 -freg-struct-return -mpreferred-stack-boundary=2
>>> -fno-unit-at-a-time -march=i686 -ffreestanding -DCONFIG_AS_CFI=1 -pipe
>>> -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx
>>> -mno-sse2 -mno-3dnow -fno-omit-frame-pointer -fno-optimize-sibling-calls -g
>>> -Wdeclaration-after-statement   -D"KBUILD_STR(s)=#s"
>>> -D"KBUILD_BASENAME=KBUILD_STR(rcutree)"
>>>  -D"KBUILD_MODNAME=KBUILD_STR(rcutree)" -c -o kernel/rcutree.o
>>> kernel/rcutree.c
>>> kernel/rcutree.c: In function `__rcu_init':
>>> kernel/rcutree.h:301: sorry, unimplemented: inlining failed in call to
>>> 'rcu_bootup_announce': function body not available
>>> kernel/rcutree.c:1740: sorry, unimplemented: called from here
>>> make[1]: *** [kernel/rcutree.o] Error 1
>>> make: *** [kernel] Error 2
>>>
>>>        There is no way ,  thru the 'make *config' methods to disable this
>>> broken stuff ,  So How may I get past this brokeness ?
>>>        And looking the posts for the 2.6.32-pre/rc the old rcu has been
>>> trashed completely .  So I am not able to even try using that .
>>>
>>>        Would someone please shed some light on this .  I really need the
>>> updates for the Fusion/mpt driver & the changes in the /md/ tree as well .
>>
>> Hmm, I see the problem, but not sure how to fix it...
>>
>> Paul, why do we have #include "rcutree_plugin.h" at the bottom
>> of rcutree.c? This looks strange for me...
>>
>> How about moving it up? At least just move upper to rcu_init().
>
> Could you please apply commit #dbe01350fa8ce0c11948ab7d6be71a4d901be151
> from Linus's git tree?  Corresponding diff attached.
>
> 							Thanx, Paul
>
> ------------------------------------------------------------------------
>
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index c1891c3..ddb79ec 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -301,7 +301,7 @@ DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
> #else /* #ifdef RCU_TREE_NONCORE */
>
> /* Forward declarations for rcutree_plugin.h */
> -static inline void rcu_bootup_announce(void);
> +static void rcu_bootup_announce(void);
> long rcu_batches_completed(void);
> static void rcu_preempt_note_context_switch(int cpu);
> static int rcu_preempted_readers(struct rcu_node *rnp);
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index ef2a58c..c03edf7 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -33,7 +33,7 @@ DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
> /*
>  * Tell them what RCU they are running.
>  */
> -static inline void rcu_bootup_announce(void)
> +static void rcu_bootup_announce(void)
> {
> 	printk(KERN_INFO
> 	       "Experimental preemptable hierarchical RCU implementation.\n");
> @@ -481,7 +481,7 @@ void exit_rcu(void)
> /*
>  * Tell them what RCU they are running.
>  */
> -static inline void rcu_bootup_announce(void)
> +static void rcu_bootup_announce(void)
> {
> 	printk(KERN_INFO "Hierarchical RCU implementation.\n");
> }

 	Thank you & Americo for responding .

 	Patch applied & same error as far as I can tell .
 	did

 	make mrproper
 	cp ../old.config .config	(same as in previous email)
 	make oldconfig
 	( time make V=1 KBUILD_VERBOSE=1 INSTALL_PATH=/boot clean all install modules_install ) >../linux-2.6.32.1d.log 2>&1
 	error'd (See below) ...

 	If there is any further info I can provide or something I can do to
 	provide ,  Please request it .
 		Tia ,  JimL

   gcc -Wp,-MD,kernel/.rcutree.o.d  -nostdinc -isystem /usr/lib/gcc/i486-slackware-linux/3.4.6/include -Iinclude  -I/usr/src/linux-2.6.32.1/arch/x86/include -include include/linux/autoconf.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -m32 -msoft-float -mregparm=3 -freg-struct-return -mpreferred-stack-boundary=2 -fno-unit-at-a-time -march=i686 -ffreestanding -DCONFIG_AS_CFI=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -Wdeclaration-after-statement   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(rcutree)"  -D"KBUILD_MODNAME=KBUILD_STR(rcutree)"  -c -o kernel/rcutree.o kernel/rcutree.c
kernel/rcutree.c: In function `__rcu_init':
kernel/rcutree.h:301: sorry, unimplemented: inlining failed in call to 'rcu_bootup_announce': function body not available
kernel/rcutree.c:1740: sorry, unimplemented: called from here
make[1]: *** [kernel/rcutree.o] Error 1
make: *** [kernel] Error 2


-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
--566704117-345244137-1261156072=:9874--

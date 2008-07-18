Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbYGRJPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbYGRJPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbYGRJPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:15:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35640 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623AbYGRJPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:15:03 -0400
Date: Fri, 18 Jul 2008 11:14:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Current git fails to compile
Message-ID: <20080718091441.GR6875@elte.hu>
References: <20080718075340.GC16453@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718075340.GC16453@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> Hi Ingo, Thomas,
> 
> Today's git fails to compile for me with
> (5b664cb235e97afbf34db9c4d77f08ebd725335e)
> 
> arch/x86/mm/pgtable.c: In function `pgd_mop_up_pmds':
> arch/x86/mm/pgtable.c:194: warning: unused variable `pmd'
> arch/x86/mm/pgtable.c: In function `pgd_prepopulate_pmd':
> arch/x86/mm/pgtable.c:222: internal compiler error: in remove_insn, at
> emit-rtl.c:3829
> Please submit a full bug report,
> with preprocessed source if appropriate.
> See <URL:http://bugzilla.redhat.com/bugzilla> for instructions.
> Preprocessed source stored into /tmp/ccJG8rDB.out file, please attach
> this to your bugreport.
> make[1]: *** [arch/x86/mm/pgtable.o] Error 1
> make: *** [arch/x86/mm] Error 2
> [root@llm11 linux-2.6]# 
> 
> [root@llm11 linux-2.6]# gcc -v
> Reading specs from /usr/lib/gcc/i386-redhat-linux/3.4.4/specs
> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
> --infodir=/usr/share/info --enable-shared --enable-threads=posix
> --disable-checking --with-system-zlib --enable-__cxa_atexit
> --disable-libunwind-exceptions --enable-java-awt=gtk
> --host=i386-redhat-linux
> Thread model: posix
> gcc version 3.4.4 20050721 (Red Hat 3.4.4-2)
> [root@llm11 linux-2.6]# 

so old-gcc crapped up.

Any chance you could try something like:

  git-bisect good v2.6.26
  git-bisect bad linus/master
  git-bisect run make arch/x86/mm/pgtable.o

... if we know which change caused this maybe we can work this gcc bug 
around.

	Ingo

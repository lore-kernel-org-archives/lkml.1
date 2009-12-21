Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbZLUJNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbZLUJNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 04:13:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbZLUJNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 04:13:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57959 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbZLUJNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 04:13:47 -0500
Date: Mon, 21 Dec 2009 10:13:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Ritesh Raj Sarraf <rrs@researchut.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.33-rc1 build failure: copy_from_user() buffer size is not
 provably correct
Message-ID: <20091221091330.GA22867@elte.hu>
References: <0io307-9ti.ln1@news.researchut.com>
 <20091221180537.089C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221180537.089C.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > This is triggered if using the 'allyesconfig' target.
> > 
> > A similar issue was this: 2886a8bdfa007053b414ab01741a98c18c376a85
> > 
> > 
> > debian-build:/tmp/all-yes-config/2.6.33-rc1# make deb-pkg
> > make KBUILD_SRC=                                         
> >   CHK     include/linux/version.h                        
> >   CHK     include/generated/utsrelease.h                 
> >   CALL    scripts/checksyscalls.sh                       
> >   CHK     include/generated/compile.h                    
> >   VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
> >   VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
> >   VDSOSYM arch/x86/vdso/vdso32-syms.lds
> >   LD      arch/x86/vdso/built-in.o
> >   LD      arch/x86/built-in.o
> >   CC      mm/migrate.o
> > In file included from /tmp/all-yes-config/2.6.33-
> > rc1/arch/x86/include/asm/uaccess.h:571,
> >                  from include/linux/uaccess.h:5,
> >                  from include/linux/highmem.h:6,
> >                  from include/linux/pagemap.h:10,
> >                  from include/linux/mempolicy.h:62,
> >                  from include/linux/migrate.h:5,
> >                  from mm/migrate.c:15:
> > In function ???copy_from_user???,
> >     inlined from ???do_pages_stat??? at mm/migrate.c:1009:
> > /tmp/all-yes-config/2.6.33-rc1/arch/x86/include/asm/uaccess_32.h:213: error: 
> > call to ???copy_from_user_overflow??? declared with attribute error: 
> > copy_from_user() buffer size is not provably correct
> 
> afaik, ingo already queued this fix.
> please wait (very) few days.
> 
> thanks.

hm, the one mm/migrate.c fix we had is already in -rc1:

 b9255850: mm: Adjust do_pages_stat() so gcc can see copy_from_user() is safe

I've Cc:-ed more folks.

	Ingo

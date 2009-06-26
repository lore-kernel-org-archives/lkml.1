Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZFZWFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZFZWFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZFZWEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:04:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751657AbZFZWEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:04:54 -0400
Date: Fri, 26 Jun 2009 15:04:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH] unifdef: teach it about defined(FOO) syntax
Message-Id: <20090626150453.77425669.akpm@linux-foundation.org>
In-Reply-To: <1158166a0906211121q51a8d320j1d9ab0e1570373da@mail.gmail.com>
References: <1158166a0906211121q51a8d320j1d9ab0e1570373da@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jun 2009 20:21:32 +0200
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> Hi,
> 
> uclibc project patched unifdef.c (which we stole from kernel)
> so that it understands defined(FOO) in addition to defined FOO,
> and also taught it to understand short-circuited evaluation
> of && and ||
> 
> The patch is attached. (Sorry, not inline, I fear Google
> web mail interface may mangle it).
> 
> I ran these commands in unpatched and patched tree:
> 
> make ARCH=i386 CROSS_COMPILE=i486-linux-uclibc- defconfig
> ln -s asm-x86 include/asm
> make ARCH=i386 CROSS_COMPILE=i486-linux-uclibc- headers_install
> 
> and then diffed usr/*. The difference clearly shows that
> new unifdef works better than old one:
> 
> 
> linux-2.6.30.test/usr/include/linux/acct.h:
> @@ -59,9 +59,7 @@ struct acct
>  	comp_t		ac_majflt;		/* Major Pagefaults */
>  	comp_t		ac_swaps;		/* Number of Swaps */
>  /* m68k had no padding here. */
> -#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
>  	__u16		ac_ahz;			/* AHZ */
> -#endif
>  	__u32		ac_exitcode;		/* Exitcode */
>  	char		ac_comm[ACCT_COMM + 1];	/* Command Name */
>  	__u8		ac_etime_hi;		/* Elapsed Time MSB */
> 
> 
> linux-2.6.30.test/usr/include/linux/soundcard.h:
> @@ -1033,7 +1033,6 @@ typedef struct mixer_vol_table {
>   */
>  #define LOCL_STARTAUDIO		1
> 
> -#if !defined(__KERNEL__) || defined(USE_SEQ_MACROS)
>  /*
>   *	Some convenience macros to simplify programming of the
>   *	/dev/sequencer interface
> @@ -1275,4 +1274,3 @@ void seqbuf_dump(void);	/* This function
>  		(SEQ_DUMPBUF(), write(seqfd, (char*)(patchx), len))
> 
>  #endif
> -#endif
> 
> ...
>

eek.  Please avoid quoting anything which looks like a patch in the
changelog.  Because when some poor schmuck comes along and tries to
apply it, patch(1) goes sniffing around in the changelog, thinks it
sees a patch and makes a huge mess of everything.


> Please apply.

Unfortunately unifdef.c got changed after 2.6.30 and this patch throws
more rejects than I am comfortable about fixing.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbXCEQ3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbXCEQ3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 11:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbXCEQ3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 11:29:54 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:57062 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbXCEQ3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 11:29:53 -0500
Date: Mon, 5 Mar 2007 17:29:35 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: (trivia) remove useless typecast around `jif' variable
In-Reply-To: <20070305161251.AE2C97FAA@paltus.tls.msk.ru>
Message-ID: <Pine.LNX.4.61.0703051724520.24366@yvahk01.tjqt.qr>
References: <20070305161251.AE2C97FAA@paltus.tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 5 2007 19:12, Michael Tokarev wrote:

>Date: Mon,  5 Mar 2007 19:12:51 +0300 (MSK)
>From: Michael Tokarev <mjt@tls.msk.ru>
>To: undisclosed-recipients:  ;

I have no clue what you sent it to, so I added linux-kernel again.



>Subject: (trivia) remove useless typecast around `jif' variable
>
>in fs/proc/proc_misc.c:show_stat() routine (which handles /proc/stat
>file), there's a local variable named 'jif' of type unsigned long,
>declared as following:
>
>static int show_stat(struct seq_file *p, void *v)
>{
>        unsigned long jif;
>
>But later on, it's explicitly casted to (unsigned long) in printf().
>Remove the useless cast, to let the compiler to do the work for us
>in case we'll want to use different type here (say, u64 or something).

In case we wanted to use different types, we would also have to
change the accompanying %lu into %llu. Only changing jif to u64 will
cause a problem, as the compiler does _not_ automatically
promote/demote types in varargs that already have a certain size. In
other words,

int foo(unsigned long x)
{
        printk("%llu\n", x);  /* and */
        printk("%lu\n", x);
}

will throw a warning (rightfully if you ask me).



Jan
-- 

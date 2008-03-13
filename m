Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbYCMXx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbYCMXx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYCMXxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:53:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:37505 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYCMXxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QNsuhUQy9gIhdPw6c/nN3x3g4JU1/oZZL0E3RWgFNFSFZtM1u31zK9cAjtiLFTUvvPUVe6Ll5q9/kbgjk080GazbPCRwfV4bLBL3VxbMf/q+P8yi55s5r9830qQXkIhrvJOGn1h7zC4+2r7Unz2G5AFFFa2wNC2FWmFjdUGdyZc=
Message-ID: <9a8748490803131653n7f1c2bd0m12e30d82bf936d03@mail.gmail.com>
Date: Fri, 14 Mar 2008 00:53:17 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: whose job is it to include various header files?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/2008, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>
>   more a philosophy question than anything but, while poking around
>  the percpu stuff today, i noticed in the header file linux/percpu.h
>  the opening snippet:
>
>   #include <linux/preempt.h>
>   #include <linux/slab.h> /* For kmalloc() */
>   #include <linux/smp.h>
>   #include <linux/string.h> /* For memset() */
>   #include <linux/cpumask.h>
>   ...
>
>  hmmm, i thought to myself (because that's how i refer to myself), i
>  wonder why this header file is including headers for kmalloc() and
>  memset() when this header file makes no reference to those routines.
>  let's see what happens if i remove them and:
>
>   $ make distclean
>   $ make defconfig    [x86]
>   $ make
>
>  ... chug chug chug ...
>
>   CC      arch/x86/kernel/nmi_32.o
>  arch/x86/kernel/nmi_32.c: In function 'check_nmi_watchdog':
>  arch/x86/kernel/nmi_32.c:81: error: implicit declaration of function 'kmalloc'
>  arch/x86/kernel/nmi_32.c:81: error: 'GFP_KERNEL' undeclared (first use in this function)
>  arch/x86/kernel/nmi_32.c:81: error: (Each undeclared identifier is reported only once
>  arch/x86/kernel/nmi_32.c:81: error: for each function it appears in.)
>  arch/x86/kernel/nmi_32.c:81: warning: assignment makes pointer from integer without a cast
>  arch/x86/kernel/nmi_32.c:118: error: implicit declaration of function 'kfree'
>  make[1]: *** [arch/x86/kernel/nmi_32.o] Error 1
>  make: *** [arch/x86/kernel] Error 2
>  $
>
>   ok, now i know.  but that means, of course, that nmi_32.c is
>  invoking kmalloc() without ever having included the necessary header
>  file for it -- it's just inheriting that from linux/percpu.h.
>
>   doesn't that (sort of) violate the kernel coding style?  if a file
>  somewhere needs the contents of some header file, isn't it that file's
>  responsibility to explicitly include it, and not quietly realize it's
>  getting it from elsewhere?
>
I agree with you completely. A file should explicitly include headers
for the stuff it uses and not rely on implicit includes done
elsewhere. Cleaning that up is going to touch a lot of files though
for no real short term gain (there is a long term gain of
maintainability though), so it's going to be a loveless job :(

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

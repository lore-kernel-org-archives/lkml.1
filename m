Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbXHHHSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbXHHHSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763079AbXHHHM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:12:26 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:48404 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761130AbXHHHMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:12:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nO1dOYZa+indsU+eytZWnV2UbD3n5DeRUsnEUrT/wO1eyt7AD63vZytbm8XsBQAWZRcaQoxHI/oHgidiuYCruQT1XYRLIF9lZfO/44Sc73bo4cPryPz7sv+6R/emJBpR4L3U0Blo4VC4STQp6u6X3kJBoesQ33TP6rWVNiZ0RC4=
Message-ID: <b6fcc0a0708080012w1794ad84ma2a3b5a84eb5b8b@mail.gmail.com>
Date: Wed, 8 Aug 2007 11:12:22 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Olaf Hering" <olaf@aepfle.de>
Subject: Re: [PATCH] remove binfmts.h from header exports
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070808061439.GB1126@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070807201603.GB31501@aepfle.de>
	 <20070807203707.GB5844@martell.zuzino.mipt.ru>
	 <20070808061439.GB1126@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Olaf Hering <olaf@aepfle.de> wrote:
> On Wed, Aug 08, Alexey Dobriyan wrote:
>
> > On Tue, Aug 07, 2007 at 10:16:03PM +0200, Olaf Hering wrote:
> > > remove linux/binfmts.h from make headers_install
> > >
> > > A recent patch added PAGE_SIZE to the part outside of __KERNEL__.
> > > qemu and ia32el have their own define of MAX_ARG_PAGES.
> >
> > Should they use kernel header instead?
>
> No, because the header will disappear. And from my understanding, the
> args limit is now gone.

OK.

> > > No package uses linux/binfmts.h, so it is safe to not provide it.
> >
> > And? Does it contain stuff which is userspace visible?
> > binfmts.h has at least CORENAME_MAX_SIZE and SUID_DUMP_*
>
> Yes, its inside __KERNEL__.

Can't you accept for a second that some stuff under __KERNEL__
was put there by mistake?

> We are talking about the part below.

No, we are talking about whole header since you're going
to unexport whole header.

> What part is useable for an application?

>From part you quoted nothing. Otherwise:

fd = open("/proc/sys/fs/suid_dumpable", 1);
snprintf(buf, sizeof(buf), "%d", SUID_DUMP_ROOT);
write(fd, buf, strlen(buf));

> #include <linux/capability.h>
>
> struct pt_regs;
>
> /*
>  * These are the maximum length and maximum number of strings passed to the
>  * execve() system call.  MAX_ARG_STRLEN is essentially random but serves to
>  * prevent the kernel from being unduly impacted by misaddressed pointers.
>  * MAX_ARG_STRINGS is chosen to fit in a signed 32-bit integer.
>  */
> #define MAX_ARG_STRLEN (PAGE_SIZE * 32)
> #define MAX_ARG_STRINGS 0x7FFFFFFF
>
> /* sizeof(linux_binprm->buf) */
> #define BINPRM_BUF_SIZE 128

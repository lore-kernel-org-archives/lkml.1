Return-Path: <linux-kernel-owner+w=401wt.eu-S1761178AbXHHGOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761178AbXHHGOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 02:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbXHHGOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 02:14:25 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:49366 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbXHHGOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 02:14:24 -0400
Date: Wed, 8 Aug 2007 08:14:39 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove binfmts.h from header exports
Message-ID: <20070808061439.GB1126@aepfle.de>
References: <20070807201603.GB31501@aepfle.de> <20070807203707.GB5844@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070807203707.GB5844@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, Alexey Dobriyan wrote:

> On Tue, Aug 07, 2007 at 10:16:03PM +0200, Olaf Hering wrote:
> > remove linux/binfmts.h from make headers_install
> > 
> > A recent patch added PAGE_SIZE to the part outside of __KERNEL__.
> > qemu and ia32el have their own define of MAX_ARG_PAGES.
> 
> Should they use kernel header instead?

No, because the header will disappear. And from my understanding, the
args limit is now gone.

> > No package uses linux/binfmts.h, so it is safe to not provide it.
> 
> And? Does it contain stuff which is userspace visible?
> binfmts.h has at least CORENAME_MAX_SIZE and SUID_DUMP_*

Yes, its inside __KERNEL__. Have you read that header already? We are
talking about the part below.
What part is useable for an application?

....
#include <linux/capability.h>

struct pt_regs;

/*
 * These are the maximum length and maximum number of strings passed to the
 * execve() system call.  MAX_ARG_STRLEN is essentially random but serves to
 * prevent the kernel from being unduly impacted by misaddressed pointers.
 * MAX_ARG_STRINGS is chosen to fit in a signed 32-bit integer.
 */
#define MAX_ARG_STRLEN (PAGE_SIZE * 32)
#define MAX_ARG_STRINGS 0x7FFFFFFF

/* sizeof(linux_binprm->buf) */
#define BINPRM_BUF_SIZE 128
....

> "userspace doesn't use header" is something headers_install has never
> been about.

Thats true.
I remember someone even wrote something for Documentation/ a few days ago.

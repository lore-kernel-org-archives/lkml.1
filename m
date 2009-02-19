Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZBSWDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZBSWDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZBSWDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:03:19 -0500
Received: from 8bytes.org ([88.198.83.132]:59495 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbZBSWDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:03:17 -0500
Date: Thu, 19 Feb 2009 23:03:15 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Hollis Blanchard <hollisb@us.ibm.com>
Cc: kvm-devel <kvm@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Avi Kivity <avi@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kvm-userspace build break (linux/types.h)
Message-ID: <20090219220315.GI2125@8bytes.org>
References: <1235080214.16221.26.camel@slate.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1235080214.16221.26.camel@slate.austin.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 03:50:14PM -0600, Hollis Blanchard wrote:
> A recent kernel merge breaks kvm-userspace build:
>         make[1]: Entering directory `/root/hollisb/kvm-userspace.git/libkvm'
>         gcc -m64 -D__x86_64__ -MMD -MF ./.libkvm.d -g -fomit-frame-pointer -Wall  -fno-stack-protector   -I /root/hollisb/kvm-userspace.git/kernel/include   -c -o libkvm.o libkvm.c
>         In file included from /usr/include/bits/fcntl.h:24,
>                          from /usr/include/fcntl.h:34,
>                          from libkvm.c:30:
>         /usr/include/sys/types.h:46: error: conflicting types for ‘loff_t’
>         /usr/include/linux/types.h:30: error: previous declaration of ‘loff_t’ was here
>         /usr/include/sys/types.h:62: error: conflicting types for ‘dev_t’
>         /usr/include/linux/types.h:13: error: previous declaration of ‘dev_t’ was here
>         [...]
> 
> I built like so:
>         ./configure
>         make -C kernel LINUX=/path/to/kvm.git sync
>         make
> 
> The problem appears to be 00bfddaf7f68a6551319b536f052040c370756b0 and
> cef3767852a9b1a7ff4a8dfe0969e2d32eb728df, both from Jaswinder Singh
> Rajput <jaswinder@infradead.org>: 
>         -#include <asm/types.h>
>         +#include <linux/types.h>
> 
> With these changes, libkvm.c ends up
> including /usr/include/linux/types.h, instead of the
> intended ../kernel/include/linux/types.h.

I had the same problem some weeks ago. IIRC I fixed it with some include
reordering in libkvm.h.

Joerg

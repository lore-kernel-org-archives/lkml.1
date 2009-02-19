Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbZBSVub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbZBSVub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbZBSVuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:50:18 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55240 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412AbZBSVuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:50:16 -0500
Subject: kvm-userspace build break (linux/types.h)
From: Hollis Blanchard <hollisb@us.ibm.com>
To: kvm-devel <kvm@vger.kernel.org>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Avi Kivity <avi@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM Linux Technology Center
Date: Thu, 19 Feb 2009 15:50:14 -0600
Message-Id: <1235080214.16221.26.camel@slate.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent kernel merge breaks kvm-userspace build:
        make[1]: Entering directory `/root/hollisb/kvm-userspace.git/libkvm'
        gcc -m64 -D__x86_64__ -MMD -MF ./.libkvm.d -g -fomit-frame-pointer -Wall  -fno-stack-protector   -I /root/hollisb/kvm-userspace.git/kernel/include   -c -o libkvm.o libkvm.c
        In file included from /usr/include/bits/fcntl.h:24,
                         from /usr/include/fcntl.h:34,
                         from libkvm.c:30:
        /usr/include/sys/types.h:46: error: conflicting types for ‘loff_t’
        /usr/include/linux/types.h:30: error: previous declaration of ‘loff_t’ was here
        /usr/include/sys/types.h:62: error: conflicting types for ‘dev_t’
        /usr/include/linux/types.h:13: error: previous declaration of ‘dev_t’ was here
        [...]

I built like so:
        ./configure
        make -C kernel LINUX=/path/to/kvm.git sync
        make

The problem appears to be 00bfddaf7f68a6551319b536f052040c370756b0 and
cef3767852a9b1a7ff4a8dfe0969e2d32eb728df, both from Jaswinder Singh
Rajput <jaswinder@infradead.org>: 
        -#include <asm/types.h>
        +#include <linux/types.h>

With these changes, libkvm.c ends up
including /usr/include/linux/types.h, instead of the
intended ../kernel/include/linux/types.h.

Avi, suggestions? More "make sync" hacks?

-- 
Hollis Blanchard
IBM Linux Technology Center


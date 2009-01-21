Return-Path: <linux-kernel-owner+w=401wt.eu-S1762445AbZAUAFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445AbZAUAFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbZAUAFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:05:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:55167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148AbZAUAFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:05:19 -0500
Subject: Confusion in usr/include/asm-generic/fcntl.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 05:34:17 +0530
Message-Id: <1232496257.3123.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usr/include/asm-generic/fcntl.h is giving 2 'make headers_check' warnings:
 usr/include/asm-generic/fcntl.h:127: leaks CONFIG_64BIT to userspace where it is not valid
 usr/include/asm-generic/fcntl.h:149: leaks CONFIG_64BIT to userspace where it is not valid

usr/include/asm-generic/fcntl.h:
--
#ifndef CONFIG_64BIT

#ifndef F_GETLK64
#define F_GETLK64       12      /*  using 'struct flock64' */
#define F_SETLK64       13
#define F_SETLKW64      14
#endif

#ifndef HAVE_ARCH_STRUCT_FLOCK64
#ifndef __ARCH_FLOCK64_PAD
#define __ARCH_FLOCK64_PAD
#endif

struct flock64 {
        short  l_type;
        short  l_whence;
        loff_t l_start;
        loff_t l_len;
        pid_t  l_pid;
        __ARCH_FLOCK64_PAD
};
#endif
#endif /* !CONFIG_64BIT */
--

#ifndef CONFIG_64BIT will always be true for userspace. So what is the use of #ifndef CONFIG_64BIT ?

Thanks,
--
JSR


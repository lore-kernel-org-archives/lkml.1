Return-Path: <linux-kernel-owner+w=401wt.eu-S1761420AbZEMToT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761420AbZEMToT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZEMToF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:44:05 -0400
Received: from www.tglx.de ([62.245.132.106]:52791 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZEMToE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:44:04 -0400
Date: Wed, 13 May 2009 21:42:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH -tip] x86: audit.c remove unnecessary global
 arraysn
In-Reply-To: <1242240694.3364.3.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0905132136300.3561@localhost.localdomain>
References: <1242240694.3364.3.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Jaswinder Singh Rajput wrote:
 
> ia32_dir_class[], ia32_write_class[], ia32_read_class[], ia32_chattr_class[]
> and ia32_signal_class[] are used only by arch/x86/kernel/audit_64.c
> which can be replace by local variables:
> 
> dir_class[], write_class[], read_class[], chattr_class[] and signal_class[]

Groan, it can be replaced by local variables, but it does not result
in the same functionality.

These audit classes are arrays of syscall numbers, which are different
for 32 and 64 bit. ia32/audit.c includes unistd_32.h not unistd.h for
exactly this reason.

Thanks,

	tglx

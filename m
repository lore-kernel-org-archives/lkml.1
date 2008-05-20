Return-Path: <linux-kernel-owner+w=401wt.eu-S1761327AbYETGp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327AbYETGp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 02:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbYETGpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 02:45:16 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:58383 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbYETGpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 02:45:15 -0400
Message-ID: <48327379.7030506@de.ibm.com>
Date: Tue, 20 May 2008 08:45:13 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       sam@ravnborg.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 1/7] kernel: call constructors
References: <48313DA2.2090108@de.ibm.com> <20080519150640.c61dca49.akpm@linux-foundation.org>
In-Reply-To: <20080519150640.c61dca49.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 19 May 2008 10:43:14 +0200
> Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> 
>> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> 
>> Call constructors during kernel init and module load. Required by the
>> gcov profiling infrastructure: gcc's profiling code uses constructors
>> to register profiling data structures.
>> 
> 
> What happens with architectures which do not use
> include/asm-generic/vmlinux.lds.h?  A quicky grep points at

In that case, no constructors would be called and as a result the gcov
debugfs directory would be empty. This should be easily fixable as the
case arises though. I've re-checked arch/*/vmlinux* and all of those
linker scripts seem to include asm-generic/vmlinux.lds.h at most via
one indirection.

> arch/m68k/kernel/vmlinux.lds.S

Includes asm-generic/vmlinux.lds.h either via vmlinux-sun3.lds or
vmlinux-std.lds.

> arch/sh/kernel/vmlinux.lds.S

Includes asm-generic/vmlinux.lds.h either via vmlinux_32.lds.S or
vmlinux_64.lds.S.

> arch/um/kernel/vmlinux.lds.S

Includes asm-generic/vmlinux.lds.h either via uml.lds.S or dyn.lds.S.


Regards,
  Peter

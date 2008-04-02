Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbYDBGum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbYDBGum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 02:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760040AbYDBGu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 02:50:29 -0400
Received: from c-24-130-11-78.hsd1.ca.comcast.net ([24.130.11.78]:39830 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759933AbYDBGu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 02:50:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, ebiederm@xmission.com,
       mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH linux-next] x86_32: fix VisualWS and Voyager kexec build failures
References: <20080401104950.83b02073.randy.dunlap@oracle.com>
Date: Wed, 02 Apr 2008 00:49:15 -0600
In-Reply-To: <20080401104950.83b02073.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Tue, 1 Apr 2008 10:49:50 -0700")
Message-ID: <m17ifgrbtg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> cc: Eric Biederman <ebiederm@xmission.com>
>
> Both Visual WS and Voyager builds fail in almost the same way (in
> linux-next) without this patch:
>
> VOYAGER:
> kernel/built-in.o: In function `crash_kexec':
> (.text+0x28588): undefined reference to `machine_crash_shutdown'
>
> VISWS:
> kernel/built-in.o: In function `crash_kexec':
> /next-20080401/kernel/kexec.c:1074: undefined reference to
> `machine_crash_shutdown'
> make[1]: *** [.tmp_vmlinux1] Error 1
>
> because arch/x86/kernel/reboot.c isn't built since CONFIG_X86_BIOS_REBOOT=n,
> so machine_crash_shutdown() isn't available.

Weird.  I haven't had a chance to update to the devel kernels lately.
And in the older kernel I have machine_crash_shutdown is in crash.c
and is indeed not dependent xyz.

I get the feeling someone refactored something and ran afoul of the
x86_32 weird subarchitecture stuff in their testing.

> This patch does seem a small bit odd since the KEXEC help text says that
> kexec is independent of the system firmware.

Yes.

> Eric, is there some other way that this should be handled?

Yes.  Move machine_crash_shutdown back into crash.c
Or find some other way to accomplish whatever cleanup was done,
so that we still compile.

Eric

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbYDBQ5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbYDBQ5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbYDBQ5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:57:14 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59052 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368AbYDBQ5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:57:10 -0400
Date: Wed, 2 Apr 2008 09:56:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: ebiederm@xmission.com (Eric W. Biederman), linux-next@vger.kernel.org,
       gcosta@redhat.com
Cc: lkml <linux-kernel@vger.kernel.org>, mingo <mingo@redhat.com>,
       tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH linux-next] x86_32: fix VisualWS and Voyager kexec build
 failures
Message-Id: <20080402095603.c5433526.randy.dunlap@oracle.com>
In-Reply-To: <m17ifgrbtg.fsf@ebiederm.dsl.xmission.com>
References: <20080401104950.83b02073.randy.dunlap@oracle.com>
	<m17ifgrbtg.fsf@ebiederm.dsl.xmission.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Apr 2008 00:49:15 -0600 Eric W. Biederman wrote:

> Randy Dunlap <randy.dunlap@oracle.com> writes:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > cc: Eric Biederman <ebiederm@xmission.com>
> >
> > Both Visual WS and Voyager builds fail in almost the same way (in
> > linux-next) without this patch:
> >
> > VOYAGER:
> > kernel/built-in.o: In function `crash_kexec':
> > (.text+0x28588): undefined reference to `machine_crash_shutdown'
> >
> > VISWS:
> > kernel/built-in.o: In function `crash_kexec':
> > /next-20080401/kernel/kexec.c:1074: undefined reference to
> > `machine_crash_shutdown'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> >
> > because arch/x86/kernel/reboot.c isn't built since CONFIG_X86_BIOS_REBOOT=n,
> > so machine_crash_shutdown() isn't available.
> 
> Weird.  I haven't had a chance to update to the devel kernels lately.
> And in the older kernel I have machine_crash_shutdown is in crash.c
> and is indeed not dependent xyz.
> 
> I get the feeling someone refactored something and ran afoul of the
> x86_32 weird subarchitecture stuff in their testing.
> 
> > This patch does seem a small bit odd since the KEXEC help text says that
> > kexec is independent of the system firmware.
> 
> Yes.
> 
> > Eric, is there some other way that this should be handled?
> 
> Yes.  Move machine_crash_shutdown back into crash.c
> Or find some other way to accomplish whatever cleanup was done,
> so that we still compile.

Well.  This is a problem in linux-next and in -mm, not yet in
mainline.  Hopefully this patch (wherever it is) won't be merged
into mainline in its present form.

---
~Randy

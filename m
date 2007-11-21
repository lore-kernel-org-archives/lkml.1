Return-Path: <linux-kernel-owner+w=401wt.eu-S1763558AbXKUAKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763558AbXKUAKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbXKUAKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:10:10 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:44324 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755697AbXKUAKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:10:09 -0500
Subject: Re: [PATCH 15/18] x86 vDSO: consolidate vdso32
From: Zachary Amsden <zach@vmware.com>
To: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071119220644.F41CA26F8C1@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
	 <20071119220644.F41CA26F8C1@magilla.localdomain>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 16:13:30 -0800
Message-Id: <1195604010.6352.237.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 14:06 -0800, Roland McGrath wrote:
> This makes x86_64's ia32 emulation support share the sources used in the
> 32-bit kernel for the 32-bit vDSO and much of its setup code.
> 
> The 32-bit vDSO mapping now behaves the same on x86_64 as on native 32-bit.
> The abi.syscall32 sysctl on x86_64 now takes the same values that
> vm.vdso_enabled takes on the 32-bit kernel.  That is, 1 means a randomized
> vDSO location, 2 means the fixed old address.  The CONFIG_COMPAT_VDSO
> option is now available to make this the default setting, the same meaning
> it has for the 32-bit kernel.  (This does not affect the 64-bit vDSO.)

I think you should drop CONFIG_COMPAT_VDSO support for 32-bit VDSO on
64-bit kernel.  This was only to hack around a broken version of glibc
that shipped with SUSE PRO 9.0, which had broken assertions based on
misinterpretation of ELF fields.  64-bit machines will never see this
glibc and the hack can die.

Perhaps it is finally time to remove the hack from 32-bit as well, and
eliminate COMPAT_VDSO entirely?  Or does it really have to live forever.

Zach


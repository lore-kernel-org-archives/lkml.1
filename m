Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbXJYQK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbXJYQK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbXJYQKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:10:14 -0400
Received: from www.tglx.de ([62.245.132.106]:54532 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbXJYQKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:10:12 -0400
Date: Thu, 25 Oct 2007 18:09:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Huang, Ying" <ying.huang@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
 runtime service support
In-Reply-To: <1193295473.23935.202.camel@caritas-dev.intel.com>
Message-ID: <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Huang, Ying wrote:

> This patch adds basic runtime services support for EFI x86_64
> system. The main file of the patch is the addition of efi.c for
> x86_64. This file is modeled after the EFI IA32 avatar.

modeled means copied and modified, right?

This is wrong. I compared efi_32.c and efi_64.c and a large amount of
the code is simply the same. The small details can be sorted out by
two sets of macros/inline functions easily.

Please fix this up.

> EFI runtime
> services initialization are implemented in efi.c. Some x86_64
> specifics are worth noting here. On x86_64, parameters passed to UEFI
> firmware services need to follow the UEFI calling convention. For this
> purpose, a set of functions named lin2win<x> (<x> is the number of
> parameters) are implemented. EFI function calls are wrapped before
> calling the firmware service.

Why needs this to be called lin2win? We do not call Windows, we call
EFI services, so please use a naming convention which is related to
the functionality of the code.

> + *
> + *  Function calling ABI conversion from SYSV to Windows for x86_64

Again, these are wrappers to access EFI and not Windows.

       tglx

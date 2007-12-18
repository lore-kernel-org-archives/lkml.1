Return-Path: <linux-kernel-owner+w=401wt.eu-S1762383AbXLREwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762383AbXLREwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 23:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbXLREwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 23:52:03 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47225 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbXLREwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 23:52:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <ak@muc.de>, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
References: <20071213235543.568682000@intel.com>
	<20071213235711.464325000@intel.com> <20071214004212.GA2735@muc.de>
	<20071214183112.GA2057@linux-os.sc.intel.com>
Date: Mon, 17 Dec 2007 21:50:10 -0700
In-Reply-To: <20071214183112.GA2057@linux-os.sc.intel.com> (Venki Pallipadi's
	message of "Fri, 14 Dec 2007 10:31:12 -0800")
Message-ID: <m11w9kd2t9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi <venkatesh.pallipadi@intel.com> writes:

> Checking the manual for this. You are right, we had missed some steps here.
> Actually, manual says on MP, PAT MSR on all CPUs must be consistent (even when
> they are not really using it in their page tables.
> So, this will change the init and shutdown parts significantly and there may be
> some challenges with CPU offline and KEXEC. We will redo this part in next
> iteration.

Well the normal kexec path is no worse then reboot.  The kdump path is a
mess but only a minor one, and with us only changing the UC- case we
can probably just ignore it and leave the system started with that
pat register set to WC :)

What we are doing really should be no worse the MTRR setup except
that disabling it at reboot is polite.

CPU online and offline that is weird, but so far it is always weird,
and I don't think ever quite correct.

Eric

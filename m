Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbZGSHWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbZGSHWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 03:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZGSHWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 03:22:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51168 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZGSHWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 03:22:14 -0400
Date: Sun, 19 Jul 2009 09:22:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@tglx.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Duplicate vsyscall/vdso gettimeofday implementations on x86_64
Message-ID: <20090719072210.GA3981@basil.fritz.box>
References: <1247868130.8334.40.camel@localhost.localdomain> <87eisfvtzv.fsf@basil.nowhere.org> <1247871284.8334.42.camel@localhost.localdomain> <87ab32wmkv.fsf@basil.nowhere.org> <1247954594.14494.12.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247954594.14494.12.camel@work-vm>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok. Ulrich mailed me with the same points earlier and here's what I
> said:

Hopefully he can fix the terrible vsyscall code in glibc too.

> 1) Keep the old vsyscall gtod implementation as is, despite it
> duplicating things. Maybe avoid the code duplication via inlined
> functions.
> 
> 2) Set the old vsyscall gtod to directly call the syscall.

There were some more like

3) Call from old vsyscall into new vDSO code. This needs to store
the randomized mapping address somewhere though.
Most options required a another page for each process.

And a couple of other variants.

> Neither of these help to avoid the non-randomized syscall instruction.

They used to be patched away to nops when not needed,
unfortunately that code was removed at some point. Perhaps
that should be readded. Most systems actually don't need them
(only those that need pmtimer) 
so you don't have a static syscall entry point on them.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

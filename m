Return-Path: <linux-kernel-owner+w=401wt.eu-S1763475AbZE3TXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763475AbZE3TXf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 15:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757537AbZE3TX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 15:23:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39655 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbZE3TX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 15:23:26 -0400
Message-ID: <4A218761.5080607@zytor.com>
Date: Sat, 30 May 2009 12:22:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Borislav Petkov <petkovbb@googlemail.com>,
       Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
       mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de, mchehab@redhat.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>	<20090528164720.0af5752b.akpm@linux-foundation.org>	<20090529103329.GB23530@aftab>	<20090529130115.a44efaee.akpm@linux-foundation.org>	<20090530081954.GA21954@liondog.tnic> <20090530014007.3c1e22d5.akpm@linux-foundation.org>
In-Reply-To: <20090530014007.3c1e22d5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 30 May 2009 10:19:54 +0200 Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
>> Also, I've been thinking about how the old(er)
>> toolchain problem can be addressed and one fairly doable thing would be
>> if I'd query the gas version in the kernel Makefile and define popcnt
>> dependent on it and for older assemblers simply slap in the opcode and
>> fixate the operands in an inline assembly so that it works.
> 
> We've done that before.  BUG() is one case (for other reasons), I think.
> 
> But if we have the code in there which uese the literal opcode, there's
> no need to query gas or to add the conditional.
> 
> Is popcnt supported on all CPUs?

Obviously not, since it's a relatively new opcode.  However, it is
supported by both Intel and AMD with the opcode F3 0F B8 /r.

The "/r" is the real problem ... it means one can't just mimic it with
hard-coding .byte directives without fixing the arguments (which means a
performance hit.)  Furthermore, the 0F B8 opcode is JMPE, which doesn't
take the same arguments either.

We have these kinds of toolchain issues regularly.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


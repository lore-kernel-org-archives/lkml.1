Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbZAHQ12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbZAHQ12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZAHQ1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:27:21 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44591 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZAHQ1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:27:20 -0500
To: Jiri Kosina <jkosina@suse.cz>
Cc: Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Subject: Re: Is 386 processor still supported?
From: Andi Kleen <andi@firstfloor.org>
References: <20090108120338.6b8b4567@zonk.pl>
	<alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz>
Date: Thu, 08 Jan 2009 17:27:30 +0100
In-Reply-To: <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz> (Jiri Kosina's message of "Thu, 8 Jan 2009 14:05:48 +0100 (CET)")
Message-ID: <87vdspwyod.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:
>
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: x86: make spinlocks available on machines without xadd insn
>
> Current kernel wouldn't compile on ancient x86 machines that don't support 
> xadd instruction, as ticket spinlocks implementation unconditionally uses 
> it.
>
> On machines without CONFIG_X86_XADD, use old-style byte spinlock 
> implementation instead.

The assumption was always the 386s don't run SMP.

So I think it would be better if you just made these xadds 
part of the UP patch implementation and patch them out on
UP systems similar to how it's done for LOCK prefixes. 
That would help non 386 UP systems too.
 
-Andi

-- 
ak@linux.intel.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYLOWLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYLOWLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbYLOWLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:11:01 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39318 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbYLOWLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:11:01 -0500
Date: Mon, 15 Dec 2008 23:23:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: don't enable MCE after suspend/resume when system was booted with "nomce"
Message-ID: <20081215222303.GW25779@one.firstfloor.org>
References: <20081212180650.GS19144@alberich.amd.com> <20081212180827.GT19144@alberich.amd.com> <87y6ylmcsz.fsf@basil.nowhere.org> <20081215185503.GA5620@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215185503.GA5620@alberich.amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=commit;h=81c7af997dafbabad464ccefba89af2b247899da
> 
> Thanks for that pointer.
> I didn't look at tip/x86/mce up to know. Is this .28 material?

I would think so, but I'm not sure the x86 maintainers think the same.

> My fix is intended for .28.
> 
> I didn't care about the lurking sysfs interface when booted with
> "nomce".  It's there and you could enable MCE with changing attributes
> but then you are actively fiddling with MCE.
> 
> The fix is for the more severe problem that mce_init() is called on
> resume and thus will enable MCE (setup cr4 and corresponding MSRs)
> which shouldn't happen when booted with "nomce".

The patch does the same (although the description doesn't say that). 
When there is no sysfs interface there won't
be any resume either because resume goes through the sysdev devices. 
So it's a cleaner and more complete fix imho.

-Andi

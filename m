Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbYLOSz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbYLOSz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 13:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYLOSzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 13:55:19 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:55389 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbYLOSzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 13:55:18 -0500
X-BigFish: VPS-40(z6c9R34a4jz1432R98dR1805M936fO3117Kzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBXLVO-01-AM5-01
Date: Mon, 15 Dec 2008 19:55:03 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: don't enable MCE after suspend/resume when
	system was booted with "nomce"
Message-ID: <20081215185503.GA5620@alberich.amd.com>
References: <20081212180650.GS19144@alberich.amd.com> <20081212180827.GT19144@alberich.amd.com> <87y6ylmcsz.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87y6ylmcsz.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 15 Dec 2008 18:55:05.0682 (UTC) FILETIME=[A4C7DB20:01C95EE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 08:08:28PM +0100, Andi Kleen wrote:
> Andreas Herrmann <andreas.herrmann3@amd.com> writes:
> 
> > Impact: fix suspend/resume bug with MCE
> >
> > A suspend/resume cycle unconditionally enables MCE
> > for the boot CPU if MCE is compiled into the kernel.
> > I.e. even a system booted with "nomce" configures MCE for the boot CPU.
> >
> > This patch ensures that MCE is not turned on for systems booted with
> > "nomce".
> 
> I have that fixed in a better way in

> http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=commit;h=81c7af997dafbabad464ccefba89af2b247899da

Thanks for that pointer.
I didn't look at tip/x86/mce up to know. Is this .28 material?
My fix is intended for .28.

I didn't care about the lurking sysfs interface when booted with
"nomce".  It's there and you could enable MCE with changing attributes
but then you are actively fiddling with MCE.

The fix is for the more severe problem that mce_init() is called on
resume and thus will enable MCE (setup cr4 and corresponding MSRs)
which shouldn't happen when booted with "nomce".


Regards,

Andreas



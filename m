Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbZBPMca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbZBPMca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbZBPMcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:32:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:41835 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbZBPMcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:32:21 -0500
Subject: Re: 2.6.29-rc5 hanging at boot when CONFIG_LOCK_STAT=y
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Adam J. Richter" <adam@yggdrasil.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090216122912.GA6302@elte.hu>
References: <20090216065053.GA23037@yggdrasil.com>
	 <20090216122912.GA6302@elte.hu>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 13:32:10 +0100
Message-Id: <1234787530.30178.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 13:29 +0100, Ingo Molnar wrote:
> * Adam J. Richter <adam@yggdrasil.com> wrote:
> 
> > Hello Peter and Ingo,
> > 
> > 	Under linux-2.6.29-rc5, and I believe all earlier 2.6.29-rc
> > releases, CONFIG_LOCK_STAT=y causes my system to hang at boot when
> > booting from lilo-22.8.  Linux-2.6.28 does not have this hang.
> > Disabling LOCK_STAT or booting from grub avoids the hang.  These are
> > sufficient workarounds for me, but I document it here in case anyone
> > else is seeing something similar or wants to take a deeper look at it.
> 
> hm, so if booting from LILO you see a hang, while when booting with GRUB 
> it works fine?
> 
> Could it be LILO messing up the kernel image loading somehow? LOCK_STAT 
> might just be the thing that brings the kernel over a specific size.

There used to be an issue long ago on s390 where the per-cpu section was
stomping on the initrd or something similar. Lockstat generates a huge
per-cpu BSS section.


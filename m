Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZGUGvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZGUGvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZGUGve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:51:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49296 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbZGUGve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:51:34 -0400
Date: Tue, 21 Jul 2009 08:51:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Doug Thompson <norsk5@yahoo.com>,
       Borislav Petkov <borislav.petkov@amd.com>, mingo@elte.hu,
       tglx@linutronix.de, aris@redhat.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
Message-ID: <20090721065128.GA29028@basil.fritz.box>
References: <20090720180446.GB16072@basil.fritz.box> <935428.51568.qm@web50110.mail.re2.yahoo.com> <20090720192229.GC16072@basil.fritz.box> <4A64D0F2.7050009@zytor.com> <4A6538EE.6000903@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6538EE.6000903@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 12:41:34PM +0900, Hidetoshi Seto wrote:
> H. Peter Anvin wrote:
> >  If you want modules to change the behavior, you're talking about a
> > *dynamic* change -- the call will point to different things at different
> > points in time -- so you need another mechanism, i.e. function pointers.
> 
> Just FYI, machine check handler on ia64 has such function pointer.
> 
> [arch/ia64/kernel/mca.c]
>     826 /* Function pointer for extra MCA recovery */
>     827 int (*ia64_mca_ucmc_extension)
>     828         (void*,struct ia64_sal_os_state*)
>     829         = NULL;

A notifier would be a much more flexible solution. Function pointers
don't really work well with multiple users, which might well happen
here.

However on the other hand I have some doubts it's really a good 
idea to expose fatal MCEs to modules. MCE is a rather critical
code path (a bit similar to an oops), with the machine
already somewhat instable in many cases and if you allow
arbitary modules to hook into that you risk long term
instability.

So if a notifier is done I would recommend to only limit
it to corrected MCEs (machine_check_poll), not fatal ones.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

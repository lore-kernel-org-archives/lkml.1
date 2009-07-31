Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZGaVLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZGaVLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZGaVLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:11:08 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34514 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbZGaVLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:11:07 -0400
X-SpamScore: -21
X-BigFish: VPS-21(z34a4jz146fK62a3L1432R98dN936eM873fizz1202hzz5a6ciz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNO060-04-E54-01
Date: Fri, 31 Jul 2009 23:10:53 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: jaswinder@kernel.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: oprofile/op_model_amd.c set return values
	for op_amd_handle_ibs()
Message-ID: <20090731211053.GO14610@erda.amd.com>
References: <1245325167.7189.9.camel@localhost.localdomain> <20090618144731.GX18016@erda.amd.com> <20090731132927.88c400cc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090731132927.88c400cc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 31 Jul 2009 21:10:54.0464 (UTC) FILETIME=[64045000:01CA1223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.07.09 13:29:27, Andrew Morton wrote:
> On Thu, 18 Jun 2009 16:47:31 +0200
> Robert Richter <robert.richter@amd.com> wrote:
> 
> > On 18.06.09 17:09:27, Jaswinder Singh Rajput wrote:
> > > 
> > > op_amd_handle_ibs() should return 0 when IBS is not present or not defined.
> > > 
> > > Fix compilation warning:
> > >  CC [M]  arch/x86/oprofile/op_model_amd.o
> > >  arch/x86/oprofile/op_model_amd.c: In function ___op_amd_handle_ibs___:
> > >  arch/x86/oprofile/op_model_amd.c:217: warning: no return statement in function returning non-void
> > > 
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  arch/x86/oprofile/op_model_amd.c |    7 +++++--
> > >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > Applied to:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git master
> > 
> 
> Something has gone badly wrong.  This patch took six weeks to turn up
> in linux-next.

Yes, at that time it was not yet quite clear of how to send oprofile
patches upstream and to linux-next. I was discussing this with Ingo
and we finally agreed to send it over tip to linux-next. It took also
some weeks to find the right workflow and types of branches for this.

All this is sorted out now. See also my current branches in the
oprofile tree:

 http://git.kernel.org/?p=linux/kernel/git/rric/oprofile.git;a=summary

In the last days I added oprofile to linux-next as a backup until Ingo
will be back. The oprofile for-next branch will work also as backup in
the future to make sure, all oprofile patches will be in time in
linux-next. I see the things working now.

Again, I also was not happy with the workflow, but I have fixed it
together with Ingo in the last weeks. That oprofile pops up in
linux-next now is the result of this. So please, see this more as
'things are working now' than 'it took 6 weeks into linux-next'. Also,
it is not too late for this, there are some more weeks to got for the
next merge window.

> 
> Apart from anything else this led me to have to fix something which was
> already fixed.
> 
> All you guys *saw* that fix and still this didn't prompt anyone to
> wonder what had gone wrong.

This went wrong, since the fix didn't make it to tip as fast as the
patch set itself. But things are fixed now and this shouln't happen
again.

> 
> My fix is better, too.  The op_amd_handle_ibs() return value is
> ignored, so it should return void.

There are pros and cons, since the handler actually should tell it did
handle the nmi, it should return something. But for some reason this
has been activly deactivated (maybe a workaround for a bug). And I
decided to not to change the code until I now the reason for it. So
the return value is ignored for now. But anyway, there aren't much
differences in the end. So I will apply your patch instead.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


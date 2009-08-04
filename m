Return-Path: <linux-kernel-owner+w=401wt.eu-S932742AbZHDPBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbZHDPBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932172AbZHDPBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:01:03 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:7447 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932159AbZHDPBA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:01:00 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz1454K1432R98dN10d1Izz1202hzzz32i203h6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KNUXP6-04-7FN-01
Date: Tue, 4 Aug 2009 17:00:46 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sachin Sant <sachinp@in.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Boot failure on x86_64 (OOPS set_cpu_sibling_map() )
Message-ID: <20090804150046.GD1870@aftab>
References: <20090730182143.eadf36e6.sfr@canb.auug.org.au>
 <4A718338.6050907@in.ibm.com>
 <20090730135623.GB16659@aftab>
 <20090803093144.GC9074@elte.hu>
 <20090803101401.GA14442@aftab>
 <20090803120739.GA29156@elte.hu>
 <20090803125059.GB14442@aftab>
 <20090804135029.GA6775@elte.hu>
 <20090804143150.GC1870@aftab>
 <20090804144741.GL7746@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090804144741.GL7746@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Aug 2009 15:00:43.0936 (UTC) FILETIME=[5729B200:01CA1514]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 04:47:41PM +0200, Ingo Molnar wrote:
> 
> * Borislav Petkov <borislav.petkov@amd.com> wrote:
> 
> > On Tue, Aug 04, 2009 at 03:50:29PM +0200, Ingo Molnar wrote:
> > > > > Mind preparing a separate branch for it (.31-rc5 based) and send me 
> > > > > a pull request so that we can share the commit between the EDAC tree 
> > > > > and the x86 tree?
> > > > 
> > > > Well, Andreas says the patches need a little polishing and he'll 
> > > > be sending updated versions soon so you can pick them up. And 
> > > > since the EDAC MCE stuff might still change before .32 merge 
> > > > window opens, let's synchronize our pull requests instead. In the 
> > > > meantime, I'll be rediffing the EDAC stuff against -tip for 
> > > > linux-next.
> > > 
> > > Would you rebase just due to this commit?
> > 
> > No, I wanted to keep the opportunity to be able to rebase the 
> > whole series until the very last minute before the merge window, 
> > should anything need to be changed...
> 
> Note that's the wrong workflow. We dont rebase Git trees really just 
> because 'something needs to be changed' - we make sure all commits 
> make sense, we fix bugs and append new changes to the end. That 
> results in a far better end result than a constant rebasing 
> workflow. See various mails from Linus on lkml about this topic. (i 
> have no handy URL for this now - maybe someone else has)

Yep, that I know and I agree with completely, I'm simply waiting in case
there are more comments on the subject (looka here, the last one was
from you :o)). Also, considering that some aspects to the design aren't
final, I'd like to be able to rebase. However, I'll make sure I switch
to incremental workflow after the majority of the issues are agreed
upon.

> > > No need for that, feel free to carry it until Andreas sends an
> > > updated version. Then i can put it into a separate .31-rc5 based
> > > topic that you can pull into the EDAC tree.
> >
> > ... and this is basically what I had in mind: After you pull them
> > in, I'll rebase my branch against yours for linux-next. I see
> > that Stephen pulls edac before -tip in linux-next so I'll ask him
> > nicely to reorder those. This approach makes most sense anyways
> > since edac relies on a bunch of x86 facilities (topology bits,
> > rd/wrmsr_on_cpus, mcheck etc) and it is only natural that it goes
> > second in linux-next, right?
> >
> > Then the pull requests will go out in the same order during the
> > merge window and we should be fine.
>
> ok. I'll wait for Andreas's next version of the patch. Feel free to
> carry the interim version - just please dont crash the x86 bootup ;-)

/me going to kick him to work faster :).

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


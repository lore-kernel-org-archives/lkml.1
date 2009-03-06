Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbZCFJJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbZCFJJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZCFJJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:09:16 -0500
Received: from ping.pong.ch ([212.103.71.101]:36815 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbZCFJJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:09:12 -0500
Date: Fri, 6 Mar 2009 10:09:06 +0100
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
	breaks resume from RAM on PowerBook
Message-ID: <20090306090906.GA5183@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch> <1236219920.7260.6.camel@pasglop> <20090305125919.GA5474@soziologie.ch> <1236318629.7260.120.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236318629.7260.120.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 04:50:29PM +1100, Benjamin Herrenschmidt wrote:
> 
> > As already said in an earlier mail, this does not make any difference. I
> > now ran some more tests:
> > 
> > -> with ppc32_defconfig: same results, resume with your commit is
> >    broken, I did not yet test if reverting the commit fixes resume.
> >    Please tell me if you are interested in this result.
> > -> with a minimal config (attached): resume does not work at all with or 
> >    without your commit. I suspect this is another bug with the same
> >    symptoms. 
> > 
> > If you have any ideas, I would be happy to do further tests. I could
> > also send you my compiles kernel (as a Debian package or a tar file) or
> > you could send me your working kernel image to see if it also works for
> > me. 
> 
> I think that .config fails due to the lack of CPU_FREQ support. I think
> I remember that specifically this powerbook model boots at low speed and
> fails to resume if not suspended at high speed. The cpufreq driver for
> powermacs knows about that and ramps up the frequency before suspend.
> 
> Can you give that a try ?

OK, with CPU_FREQ enabled I have the same results as with
ppc32_defconfig or my full config. It fails to resume with your commit
and it works if I revert that commit. 

> 
> In fact I verified on mine that your minimum config fails the same way
> you described but it works when I re-enable cpufreq support.

So you are able to resume with my minimal config + CPU_FREQ? This would
be really strange if it is really the exact same model.

To verify if we really have the same model I included some data below. I
also included the gcc and binutils versions.

Please tell me if you have any further ideas on what to test.

Gaudenz


/proc/cpuinfo:
processor	: 0
cpu		: 7447A, altivec supported
clock		: 1666.666000MHz
revision	: 1.5 (pvr 8003 0105)
bogomips	: 33.15
timebase	: 8320000
platform	: PowerMac
model		: PowerBook5,8
machine		: PowerBook5,8
motherboard	: PowerBook5,8 MacRISC3 Power Macintosh 
detected as	: 287 (PowerBook G4 15")
pmac flags	: 00000019
L2 cache	: 512K unified
pmac-generation	: NewWorld
Memory		: 1536 MB

lspci -n:
0000:00:0b.0 0600: 106b:0066
0000:00:10.0 0300: 1002:4e50
0001:10:0b.0 0600: 106b:0067
0001:10:11.0 0280: 14e4:4318 (rev 02)
0001:10:14.0 0607: 104c:ac56
0001:10:15.0 0c03: 1033:0035 (rev 43)
0001:10:15.1 0c03: 1033:0035 (rev 43)
0001:10:15.2 0c03: 1033:00e0 (rev 04)
0001:10:17.0 ff00: 106b:003e
0002:24:0b.0 0600: 106b:0068
0002:24:0d.0 ff00: 106b:0069
0002:24:0e.0 0c00: 106b:006a
0002:24:0f.0 0200: 106b:006b

gcc --version:
gcc (Debian 4.3.3-5) 4.3.3

ld --version:
GNU ld (GNU Binutils for Debian) 2.19.1
-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~

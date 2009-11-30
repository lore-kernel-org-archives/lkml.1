Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZK3T5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZK3T5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZK3T5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:57:08 -0500
Received: from cnc.isely.net ([64.81.146.143]:47113 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZK3T5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:57:07 -0500
Date: Mon, 30 Nov 2009 13:57:13 -0600 (CST)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@isely.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-media@vger.kernel.org
Subject: Re: [GIT PULL for 2.6.32] V4L/DVB updates
In-Reply-To: <20091130115701.40c92b2c@pedra>
Message-ID: <alpine.DEB.1.10.0911301341320.20937@cnc.isely.net>
References: <4B103CE1.8050303@redhat.com> <200911272240.02930.s.L-H@gmx.de> <200911280357.58116.hverkuil@xs4all.nl> <alpine.DEB.1.10.0911281425240.5482@ivanova.isely.net> <20091130115701.40c92b2c@pedra>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Mauro Carvalho Chehab wrote:

> Em Sat, 28 Nov 2009 14:33:30 -0600 (CST)
> Mike Isely <isely@isely.net> escreveu:
> 
> > 
> > Mauro:
> > 
> > I had also posted up two high priority pvrusb2 patches that should 
> > really be cherry-picked for 2.6.32.  You've already pulled them into 
> > v4l/dvb and I did mark them as high priority at the time.
> > 
> > These patches enable use of FX2 microcontroller firmware that is 16KB in 
> > size.  Hauppauge is no longer shipping 8KB firmware for HVR-1950 and 
> > HVR-1900 and without these changes then those devices won't work AT ALL 
> > in kernel 2.6.32.
> > 
> > You can find these within the v4l-dvb Mercurial repository here:
> > 
> > Changeset 13495:87c3853fe2b3 
> > Subject: pvrusb2: Support 16KB FX2 firmware
> > http://linuxtv.org/hg/v4l-dvb/rev/87c3853fe2b3
> > 
> > Changeset 13500:d4c418d4b25c
> > Subject: pvrusb2: Fix lingering 16KB FX2 Firmware issues
> > http://linuxtv.org/hg/v4l-dvb/rev/d4c418d4b25c
> > 
> > I do not believe these patches have any ordering dependencies with other 
> > patches, though between the two the second one technically should come 
> > after the first.
> 



> There are. Picking just those patches broke compilation.

Mauro:

Please forward to me the compilation errors.  Right now I am just not 
seeing how a patch this trivial could have any compilation dependencies.  
And unfortunately I will not be able to reproduce your build setup until 
at least Tuesday night.  I must be blind.


> 
> Also, it seemed too late for adding support for newer boards/firmware when Linus
> is about to release a kernel.

This is not a new feature.  It's a bug fix due to something that 
Hauppauge recently did.  Hauppauge is NO LONGER officially distributing 
FX2 firmware with their hardware which the driver can use.  This simply 
prevents any new HVR-1950 / HVR-1900 users from working under Linux.  
This fixes breakage for previously working hardware.  The root cause is 
simple - the firmware blob is just larger now - and the fix is trivial.  
It absolutely needs to go in.  In fact, this should go back to a 
2.6.31.x and a 2.6.27.x release as well, though in those cases I have to 
figure out if driver source code is still close enough for the same 
patches to still work.

I am sorry this is showing up late for you.  There are multiple reasons 
for this.  However I did mark these patches as "high priority", 
following your v4l-dvb changeset process.  I did comment on the pull 
request that these were important but I guess I needed to also 
specifically call these out in the pull request text as well.

If these don't get in now as part of the official 2.6.32 release, these 
absolutely need to be queued for 2.6.32.1.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

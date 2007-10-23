Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbXJWQt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbXJWQt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbXJWQtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:49:49 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:42755 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbXJWQtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:49:49 -0400
Date: Tue, 23 Oct 2007 19:49:45 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Philippe Elie <phil.el@wanadoo.fr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] oProfile: oops when profile_pc() return ~0LU
Message-ID: <20071023164945.ntfapvcvmxg2x5gy@m.safari.iki.fi>
Mail-Followup-To: Philippe Elie <phil.el@wanadoo.fr>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071021120842.GA2886@zaniah> <alpine.LFD.0.999.0710221936130.30120@woody.linux-foundation.org> <20071023101007.3y62tufa6yxrqk4w@m.safari.iki.fi> <20071023161321.GA2884@zaniah>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023161321.GA2884@zaniah>
User-Agent: Mutt/1.5.16 (2007-10-15)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 18:13:21 +0200, Philippe Elie wrote:
> On Tue, 23 Oct 2007 at 13:10 +0000, Sami Farin wrote:
> 
> > On Mon, Oct 22, 2007 at 19:38:10 -0700, Linus Torvalds wrote:
> > > 
> > > This set of two patches look ok by me, but I'd like sign-offs.. Also, were 
> > > they tested and found to fix the problem by Sami?
> > > 
> > > 		Linus
> 
> For the signed-offs I thought the From: was an implicit Signed-offs.
> 
> Test was done privately, Sami helped to narrow down the trouble, but
> he didn't test the last patch, nothing bad on Sami side, I was too
> confident the fix was obvious after narrowing it.
> 
> > 
> > The previous patch I tested by Philippe, oprof-fix-profile_pc-use.patch,
> > worked ok, but with this latest patch oprofiled aborts.
> > But kernel does not oops or print msgs.
> 
> argh, I just moved the wrong eip from kernel to user space where the same
> problem occur too, *sighs*, since I can't reproduce Sami problem, my own
> test obviously worked...
> 
> Sami, can you test this new patch. After testing can you report
> the contents of /dev/oprofile/stats/cpu*/sample_invalid_eip ?

cat /dev/oprofile/stats/cpu?/sample_invalid_eip; sleep 10; cat /dev/oprofile/stats/cpu?/sample_invalid_eip
834
835
0
0
906
911
0
0

For some reason there are four directories, but I have
only two CPUs in reality.

And oprofiled survives the test OK.

> Linus, there is two way to fix this problem, the attached patch fix it
> by sanitizing the sampled eip, the other is to replace the use of
> profile_pc(); by instruction_pointer(); in cpu_buffer.c, that one was
> tested by Sami  but 1) it'll break the 'use oprofile as a sort of lockometer'
> 2) I think sanitizing the eip will be necessary anyway as I'm not really
> confident than instruction_pointer() can never return weird eip on some
> weird arch and/or some weird circumstances.

-- 
Do what you love because life is too short for anything else.


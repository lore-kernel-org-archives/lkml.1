Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbZDGJzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbZDGJzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbZDGJyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:54:50 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33120 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZDGJyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:54:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rthdVZuL8x7yV3LY2ldP/T17XqT2eVuJUYg7iP46wATBt6nH1n2bFMoQ7RswpQRX60
         KFpFhx3BMNkWFUcl4m8Q9ahjCP1Ur8bbor1ABdTv9DaxyqMOEYSE9tSVn3BVszpvatq/
         JMVAD1TUWhUORv8IkX27Zk+b3TOnMscv+WOlg=
Date: Tue, 7 Apr 2009 11:54:44 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrey Borzenkov <arvidjaar@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: commit 66c1ca breaks fbdev mode switching
Message-ID: <20090407095443.GA9526@linux>
References: <498817E2.3020008@gmail.com> <1233783983-28802-1-git-send-email-righi.andrea@gmail.com> <200903221748.42871.arvidjaar@gmail.com> <200903221857.20473.rjw@sisk.pl> <20090322145219.ad294615.akpm@linux-foundation.org> <20090406204718.ce4909b3.krzysztof.h1@poczta.fm> <20090406214528.GA17259@linux> <alpine.LRH.2.00.0904071105040.24773@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0904071105040.24773@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 11:17:00AM +0200, Geert Uytterhoeven wrote:
> On Mon, 6 Apr 2009, Andrea Righi wrote:
> > On Mon, Apr 06, 2009 at 08:47:18PM +0200, Krzysztof Helt wrote:
> > > The commit 66c1ca breaks fbdev mode switching. The first mode
> > > (selected with mode_option or during boot) is ok but every mode
> > > switch with fbset locks up computer. If the commit is reverted
> > > mode switching works correctly.
> > > 
> > > I do not understand why. I would be grateful if someone else
> > > can confirm the problem as well.
> > > 
> > > The commit's details are:
> > > 
> > > commit 66c1ca019078220dc1bf968f2bb18421100ef147
> > > Author: Andrea Righi <righi.andrea@gmail.com>
> > > Date:   Tue Mar 31 15:25:18 2009 -0700
> > > 
> > >     fbmem: fix fb_info->lock and mm->mmap_sem circular locking dependency
> > 
> > Any lockdep info or oops? it just locks up the system?
> 
> # echo d > /proc/sysrq-trigger
> 
> [  187.654947] INFO: lockdep is turned off.
> 
> Strange, I do have lockdep enabled:
> 
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_LOCKDEP=y
> CONFIG_DEBUG_LOCKDEP=y

Probably because lockdep reported the first lock bug and disabled the
checking for the next lock bugs, to avoid log flooding of follow-up
bugs. Search the first lockdep occurrence in dmesg.

-Andrea

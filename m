Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbYFPDGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbYFPDGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 23:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYFPDFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 23:05:55 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:33374 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYFPDFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 23:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=So90LMBKMeAMS/9ssEc6SeyTHZtUMICbJeBohwAZwsgECh9eRKMuizSoCuIRjkkuI1
         aVyrtFfBN/dY3z0wVoU2LX7oQgwuw74A33g49REY8qr5UHRHLQFAr1VZaZmYqhAUD+V7
         aZ/Y5TXUZ129eRRSQq9bYdREvvqoFMobtQqDU=
Date: Mon, 16 Jun 2008 07:01:54 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080616030154.GA7445@martell.zuzino.mipt.ru>
References: <20080614144200.GA26421@linux.vnet.ibm.com> <20080614145839.GA10523@tv-sign.ru> <20080614181212.GB26421@linux.vnet.ibm.com> <20080614194338.GA4820@martell.zuzino.mipt.ru> <20080615033001.GE26421@linux.vnet.ibm.com> <20080615162150.GA8289@martell.zuzino.mipt.ru> <20080615181710.GA17915@linux.vnet.ibm.com> <alpine.LFD.1.10.0806151323101.2949@woody.linux-foundation.org> <20080615232754.GD17915@linux.vnet.ibm.com> <alpine.LFD.1.10.0806151633290.2949@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806151633290.2949@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 04:38:24PM -0700, Linus Torvalds wrote:
> On Sun, 15 Jun 2008, Paul E. McKenney wrote:
> >
> > If that is the right thing to do.  I would feel better about it if I
> > could reproduce the failure.
> 
> Is there some configuration thing that might make it happen for Alexey but 
> not for you? The only obvious one is the normal PREEMPT thing, but 
> PREEMPT_RCU obviously depends on that, so there must be something else.
> 
> CONFIG_SMP? CONFIG_NO_HZ? CONFIG_[RT|FAIR]_GROUP_SCHED? There's a number 
> of config options that change scheduling details..

The only way I can "fix" rcutorture here is SMP=n (not maxcpus=1!).

Among things tried and do not matter are NO_HZ, HIGH_RES_TIMERS, turning off
debugging options (one by one and in bulk), DEBUG_PER_CPU_MAPS, HZ tweaks,
SCHED_MC.

All of this doesn't help, but SMP=n does.


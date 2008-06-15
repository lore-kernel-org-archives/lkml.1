Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbYFOUdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbYFOUdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 16:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYFOUdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 16:33:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbYFOUdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 16:33:40 -0400
Date: Sun, 15 Jun 2008 13:32:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Adrian Bunk <bunk@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
In-Reply-To: <20080615181710.GA17915@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.1.10.0806151323101.2949@woody.linux-foundation.org>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.BVD.E3vSIB@albercik> <20080613135255.GB21341@cs181133002.pp.htv.fi> <20080614144200.GA26421@linux.vnet.ibm.com> <20080614145839.GA10523@tv-sign.ru> <20080614181212.GB26421@linux.vnet.ibm.com>
 <20080614194338.GA4820@martell.zuzino.mipt.ru> <20080615033001.GE26421@linux.vnet.ibm.com> <20080615162150.GA8289@martell.zuzino.mipt.ru> <20080615181710.GA17915@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 15 Jun 2008, Paul E. McKenney wrote:
> > 
> > Both patches (independently) do not help with rcutortures failures:
> > 
> > [   58.968404] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval = 5
> > [  159.044524] rcu-torture: rtc: 0000000000000000 ver: 53859 tfle: 0 rta: 53859 rtaf: 18 rtf: 53797 rtmbe: 0
> > [  159.044527] rcu-torture: !!! Reader Pipe:  65565142 4275 1 0 0 0 0 0 0 0 0
> > [  159.044529] rcu-torture: Reader Batch:  65564196 5207 7 3 1 1 0 1 1 0 1
> > [  159.044530] rcu-torture: Free-Block Circulation:  53858 53853 53846 53843 53834 53825 53816 53808 53803 53797 0
> > [  159.044976] rcu-torture:--- End of test: FAILURE: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval = 5
> 
> And the repeat-by is simply running LTP in parallel with rcutorture?
> This is a one-hour run of rcutorture or thereabouts?

Should we mark PREEMPT_RCU as BROKEN for now? I don't know if anybody 
really enables it, but it might be a good idea to make sure people don't 
do so thinking it's good..

		Linus

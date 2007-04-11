Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXDKVbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXDKVbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 17:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030185AbXDKVbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 17:31:08 -0400
Received: from main.gmane.org ([80.91.229.2]:53062 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbXDKVbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 17:31:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: init's children list is long and slows reaping children.
Date: Wed, 11 Apr 2007 17:24:13 -0400
Message-ID: <461D51FD.5010506@tmr.com>
References: <46159987.6090006@redhat.com>	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>	<m1hcru9rki.fsf@ebiederm.dsl.xmission.com>	<20070406104301.GB19755@lnx-holt.americas.sgi.com>	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>	<20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu>	<m11wix73ut.fsf@ebiederm.dsl.xmission.com>	<20070410134814.GA28016@elte.hu>	<m17iskz3i8.fsf@ebiederm.dsl.xmission.com>	<20070410164441.GB104@tv-sign.ru> <461D3D3E.2060709@tmr.com> <m1veg2r7hy.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <m1veg2r7hy.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Bill Davidsen <davidsen@tmr.com> writes:
> 
>> As long as the original parent is preserved for getppid(). There are programs
>> out there which communicate between the parent and child with signals, and if
>> the original parent dies, it undesirable to have the child getppid() and start
>> sending signals to a program not expecting them. Invites undefined behavior.
> 
> Then the programs are broken.  getppid is defined to change if the process
> is reparented to init.
> 
The short answer is that kthreads don't do this so it doesn't matter.

But user programs are NOT broken, currently getppid returns either the 
original parent or init, and a program can identify init. Reparenting to 
another pid would not be easily noted, and as SUS notes, no values are 
reserved to error. So there's no way to check, and no neeed for 
kthreads, I was prematurely paranoid.

Presumably user processes will still be reparented to init so that's not 
an issue. Since there's no atomic signal_parent() the ppid could change 
between getppid() and signal(), but that's never actually been a problem 
AFAIK.

Related: Is there a benefit from having separate queues for original 
children of init and reparented (to init) tasks? Even in a server would 
there be enough to save anything?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot


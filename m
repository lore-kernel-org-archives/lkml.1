Return-Path: <linux-kernel-owner+w=401wt.eu-S1751747AbXDJJdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbXDJJdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 05:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbXDJJdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 05:33:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34055 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbXDJJdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 05:33:51 -0400
Message-ID: <461B59F5.6060300@garzik.org>
Date: Tue, 10 Apr 2007 05:33:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <4616CBF0.7090606@garzik.org> <20070409172339.48d661d6.akpm@linux-foundation.org> <20070410015912.GE1994@redhat.com> <20070409193056.6b52c354.akpm@linux-foundation.org> <20070410074422.GA30507@flint.arm.linux.org.uk> <20070410085901.GA13662@elte.hu>
In-Reply-To: <20070410085901.GA13662@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
>> One per PC card socket to avoid the sysfs locking crappyness that 
>> would otherwise deadlock, and to convert from the old unreadable state 
>> machine implementation to a much more readable linearly coded 
>> implementation.
>>
>> Could probably be eliminated if we had some mechanism to spawn a 
>> helper thread to do some task as required which didn't block other 
>> helper threads until it completes.
> 
> looks like the perfect usecase for threadlets. (threadlets only use up a 
> separate context if necessary and can be coded in the familiar 
> sequential/linear model)

Same response as to Andrew:  AFAICS that just increases complexity.

The simple path for programmers is writing straightforward code that 
does something like

	blah
	msleep()
	blah

or in pccardd's case,

	mutex_lock()
	blah
	mutex_unlock()

to permit sleeping without having to write more-complex code that deals 
with context transitions.

For slow-path, infrequently executed code, it is best to keep it as 
simple as possible.

	Jeff



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbYKROuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbYKROuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYKROt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:49:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:34235 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYKROt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:49:57 -0500
Date: Tue, 18 Nov 2008 06:49:43 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, rml@tech9.net,
       Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: Active waiting with yield()
Message-ID: <20081118064943.332516f7@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0811180921450.12274@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
	<20081114190616.30dd273e@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
	<1226696221.7685.8148.camel@twins>
	<Pine.LNX.4.64.0811141630590.6783@hs20-bc2-1.build.redhat.com>
	<1226789714.8172.0.camel@lappy.programming.kicks-ass.net>
	<Pine.LNX.4.64.0811171228500.4019@hs20-bc2-1.build.redhat.com>
	<20081117180149.7a48d2e9@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811180921450.12274@hs20-bc2-1.build.redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 09:34:16 -0500 (EST)
> So what are the reasons why you (and others) are against active
> waiting? All you are saying is that my reasons are wrong, but you
> haven't single example when active waiting causes trouble. If there
> is a workload when waiting 1ms-to-10ms with mdelay(1) on driver
> unload would cause discomfort to the user, describe it.
> 

mdelay()
* costs you quite a bit of power
* will cause your cpu to go to full speed
* makes it more likely that your fan goes on
* takes away CPU time from others who do want to run
  - including the guy you are waiting for!
* if you do it with interrupts off you can even cause time skew
* adds 10 milliseconds of latency to the entire system, which is very
  user noticable in a desktop environment (the threshold for that is
  like 1 or 2 milliseconds total)

now there are some cases, mostly during error recovery or driver init
slowpaths where mdelay() can be justified, but "I'm too lazy to use a
waitqueue or other sleeping construct" is not one of them.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZDUSAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZDUSAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZDUR7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:59:55 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:31653 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZDUR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:59:53 -0400
X-IronPort-AV: E=Sophos;i="4.40,225,1238976000"; 
   d="scan'208";a="155410082"
Date: Tue, 21 Apr 2009 10:59:52 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       David Brownell <david-b@pacbell.net>, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090421175952.GA20146@cuplxvomd02.corp.sa.net>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net> <20090421064346.GB8020@elte.hu> <200904210013.48551.david-b@pacbell.net> <1240333871.3632.70.camel@macbook.infradead.org> <20090421172929.GC8251@cuplxvomd02.corp.sa.net> <alpine.LFD.2.00.0904211036140.2199@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904211036140.2199@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Tue, Apr 21, 2009 at 10:37:41AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 21 Apr 2009, David VomLehn wrote:
> > 
> > What in the world are users going to do when they see a message about
> > output being lost? There is no way to recover the data and no way to
> > prevent it in the future. I don't think this is a good approach.
> 
> Sure there is. The console messages are saved too, so doing 'dmesg' will 
> get you all the data that was generated before the console went on-line.
> 
> We _already_ lose data in that sense (although we could replay it for the 
> first console connected - maybe we even do, I'm too lazy to check).

There are two different things coming out on the console, kernel log buffer
messages and userspace output to /dev/console. Kernel log buffer output
is replayed for each console as it connects. There might be quite a bit of
it, but it is pretty much the same from boot to boot, so the guy working on
the kernel, me, can tune the size of log_buf pretty easily. This is not
the problem.

The problem is the userspace output to /dev/console. I work in the embedded
space and my box does not simply throw up a few windows and wait placidly for
the user to do something. Instead, it immediately starts running a whole bunch
of software with a whole bunch of startup messages. In short order, I am
running over 300 threads. I have no control over how much output comes out,
I have no idea how much kernel memory to allocate for this, and I'm quote sure
it's enough that I wouldn't want to waste that much space even if I did. No
matter what, this looks like we'd need a new tunable for the size.

And then, what happens if I *never* get a console, because one isn't plugged
in? This happens a lot in the embedded world. How long am I supposed to keep
around this big chunk of buffered data? Sounds like I need *another* tunable.
Yuck.

> 			Linus

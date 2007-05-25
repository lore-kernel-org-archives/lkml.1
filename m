Return-Path: <linux-kernel-owner+w=401wt.eu-S1764888AbXEYSGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764888AbXEYSGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763446AbXEYSGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:06:10 -0400
Received: from no-dns-yet.demon.co.uk ([83.105.13.114]:37322 "EHLO
	mailgate.netunix.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1763037AbXEYSGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:06:08 -0400
Message-ID: <46572507.6010800@netunix.com>
Date: Fri, 25 May 2007 19:03:51 +0100
From: Chris Newport <crn@netunix.com>
Reply-To: crn@netunix.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7) Gecko/20040618
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com> <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org> <20070524193740.GA6787@elte.hu> <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org> <20070525101105.GA9268@elte.hu> <4656CE39.8050800@netunix.com> <alpine.LFD.0.98.0705250937550.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705250937550.26602@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry, I did not make myself clear.

Linus Torvalds wrote:

>On Fri, 25 May 2007, Chris Newport wrote:
>  
>
>>Maybe we should take a hint from Solaris.
>>    
>>
>
>No. Solaris is shit. They make their decisions based on "we control the 
>hardware" kind of setup.
>  
>
Not really a Solaris feature. This is a feature of the  Openboot  PROM
which is also used by several other vendors.
The Openboot PROM knows how to write to disk. The same should
apply on Apple hardware and others which use the openboot
convention.

If dumps are enabled (disabled by default in a file read at boot) the
crash() function need only  set a couple of registers and do a prom
interrupt. At this point the kernel is no longer involved so broken
drivers etc are not an issue.

The cute bit is that the SunOS debug program can be called as
debug $DUMPFILE and it takes you to the failure point just like
a tracefile.

Crashdumps should not be enabled by default, they can chew rather
a lot of disk space making a crashdump.datetime file every time
something breaks <B-).
In most cases only developers will use this but it does resolve the
problem of error messages vanishing before they can be saved.


>  
>
>>If the kernel crashes Solaris dumps core to swap and sets a flag.
>>At the next boot this image is copied to /var/adm/crashdump where
>>it is preserved for future debugging. Obviously swap needs to be
>>larger than core, but this is usually the case.
>>    
>>
>
>(a) it's not necessarily the case at all on many systems
>
>(b) _most_ crashes that are real BUG()'s (rather than WARN_ON()'s) leave 
>    the system in such a fragile state that trying to write to disk is the 
>    _last_ thing you should do.
>
>    Linux does the right thing: it tries to not make bugs fatal. 
>    Generally, you should see an oops, and things continue. Or a 
>    WARN_ON(), and things continue. But you should avoid the "the machine 
>    is now dead" cases.
>
>(c) have you looked at the size of drivers lately? I'd argue that *most* 
>    bugs by far happen in something driver-related, and most of our source 
>    code is likely drivers.
>
>    Writing to disk when the biggest problem is a driver to begin with 
>    is INSANE.
>
>So the fact is, Solaris is crap, and to a large degree Solaris is crap 
>exactly _because_ it assumes that it runs in a "controlled environment".
>
>Yes, in a controlled environment, dumping the whole memory image to disk 
>may be the right thing to do. BUT: in a controlled environment, you'll 
>never get the kind of usage that Linux gets. Why do you think Linux (and 
>Windows, for that matter) took away a lot of the market from traditional 
>UNIX? 
>
>Answer: the traditional UNIX hardware/control model doesn't _work_. People 
>want more flexibility, both on a hardware side and on a usage side. And 
>once you have the flexibility, the "dump everything to disk" is simply not 
>an option any more.
>
>Disk dumps etc are options at things like wall street. But look at the bug 
>reports, and ask yourself how many of them happen at Wall Street, and how 
>many of them would even be _relevant_ to somebody there? 
>
>So forget about it. The whole model is totally broken. We need to make 
>bug-reports short and sweet, enough so that random people can 
>copy-and-paste them into an email or take a digital photo. Anything else 
>IS TOTALLY INSANE AND USELESS!
>
>			Linus
>  
>


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYCMOZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYCMOZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYCMOY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:24:56 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:35593 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYCMOYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:24:55 -0400
Message-ID: <47D937A2.9070305@aitel.hist.no>
Date: Thu, 13 Mar 2008 15:18:10 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>, Jan Knutar <jk-lkml@sci.fi>,
       linux-kernel@vger.kernel.org, Hans-Peter Jansen <hpj@urpla.net>,
       Jiri Kosina <jkosina@suse.cz>, David Newall <davidn@davidnewall.com>,
       Theodore Tso <tytso@mit.edu>, "Fred ." <eldmannen@gmail.com>
Subject: Re: Keys get stuck
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <200803122222.05663.hpj@urpla.net> <1205386933.4797.22.camel@marge.simson.net> <200803131148.22056.jk-lkml@sci.fi> <1205407693.6686.16.camel@marge.simson.net> <20080313120238.GA3860@localhost.ift.unesp.br>
In-Reply-To: <20080313120238.GA3860@localhost.ift.unesp.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos R. Mafra wrote:
> On Thu 13.Mar'08 at 12:28:13 +0100, Mike Galbraith wrote:
>   
>> [...]
>> Swap can definitely keep X off the cpu for extended periods,
>> [...]
>>     
>
> So I would like to ask if swap letting X (and everything else
> in my experience) out of the cpu for extended periods is
> considered normal behaviour, in the sense that nobody is
> trying to "fix" it (due to it being considered impossible
> to fix)...?
>   
Yes, this is perfectly normal. A heavily swapping machine
will swap out parts of X.

Now, if X has a need for low-latency for keyboard handling,
then the X developers can use mlock to lock
the X keyboard service in memory, and make it a real-time
(or at least high priority) process too.  This should
avoid the problem even with extreme swapping and/or
high cpu load.

> Sorry for being off-topic, but I run a minimal Window Maker
> desktop in a P4 3.0 GHz with 512 MB of RAM (around 140 MB
> being used as per 'free'), and trying to load a 380 MB text
> file in xjed editor makes my whole desktop quite unfair...
> it takes tens of seconds to switch desktop, type things in
> the terminal etc. 
>
>   
Seems ou use too much memory then. If xjed
wastes memory (by bringing the entire file into memory
in one go) then you'll get some swapping.

> When xjed finishes loading the text file, everything comes
> back to "fair" again.
>
> Is there some law in the nature of computers which says
> that when swapping everything else waits for swap to finish 
> its business? I hope not :-)
>   
No such law, but there are badly implemented software
around. If xjed is capable of delaying all X events while
loading the file, for example . . .

Helge Hafting

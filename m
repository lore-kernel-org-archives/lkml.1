Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbZC0MGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbZC0MGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZC0MGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:06:35 -0400
Received: from fornax.pixelized.ch ([88.198.8.169]:60460 "EHLO
	fornax.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZC0MGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:06:35 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Mar 2009 08:06:34 EDT
Message-ID: <49CCBFC4.7070707@cateee.net>
Date: Fri, 27 Mar 2009 13:00:04 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements
References: <20090325185824.GO32307@mit.edu>	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>	<20090325215137.GQ32307@mit.edu>	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>	<20090325235041.GA11024@duck.suse.cz>	<20090326090630.GA9369@elte.hu>	<20090326113705.GV32307@mit.edu>	<20090326140312.GB14822@elte.hu>	<20090326144707.GA6239@mit.edu>	<alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>	<20090326170714.GF6239@mit.edu>	<alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326185900.166a1097@lxorguk.ukuu.org.uk>
In-Reply-To: <20090326185900.166a1097@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> And what's the argument for not doing it in the kernel?
>>
>> The fact is, "atime" by default is just wrong.
> 
> It probably was a wrong default - twenty years ago. Actually it may well
> have been a wrong default in Unix v6 8)
> 
> However
> - atime behaviour is SuS required

so I propose an other mount option along to strictatime:
nowatime: it give the actual time as atime:
it is totally useless, but fast *and* POSIX compatible:
- no disk writes on accesses
- POSIX doesn't mandate the behaviour of other processes, so
   we simulate that fs are scanned at every fs-tick.
- IMHO more programs break, but in this case only
   the POSIX incompatible programs.


> - there are users with systems out there using atime and dependant on
>   proper atime

This is the real problem.

ciao
	cate


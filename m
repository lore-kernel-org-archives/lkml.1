Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZEJBAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZEJBAG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 21:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbZEJA7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 20:59:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:35079 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbZEJA7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 20:59:53 -0400
Message-ID: <4A062702.8020404@kernel.org>
Date: Sun, 10 May 2009 09:59:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: petkovbb@gmail.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: 2.9.29.2: ide-tape: panic when probing device at boot
References: <200905080700.n48704BR031273@turbo.physics.adelaide.edu.au> <200905091757.49697.bzolnier@gmail.com> <20090509161801.GB5749@liondog.tnic>
In-Reply-To: <20090509161801.GB5749@liondog.tnic>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 10 May 2009 00:59:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Borislav Petkov wrote:
> Hi,
> 
> On Sat, May 09, 2009 at 05:57:49PM +0200, Bartlomiej Zolnierkiewicz wrote:
>> [ cc:ing linux-ide and knowledgeable people ]
>>
>> Borislav/Tejun:
>>
>> Is the 2.6.29 problem the same thing that was fixed recently?
> 
> I'll let Tejun answer that one since I don't get an oops. However, now
> that I have an ide-tape hardware here, I do get something DMA-related
> failing during boot:
> 
> [    1.677012] hdb: Seagate STT8000A, ATAPI TAPE drive
> 
> ..
> 
> [    1.701097] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> [    1.708289] hdb: bad DMA info in identify block
> [    1.712872] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> 
> ..
> 
> [    3.450381] Uniform CD-ROM driver Revision: 3.20
> [    5.467347] ide-tape: hdb <-> ht0: Seagate STT8000A rev 5.44
> [    5.484852] ide-tape: hdb <-> ht0: 88KBps, 14*26kB buffer, 400ms tDS
> 
> and more specifically the bad DMA info in identify block thing above. I
> haven't looked into it yet but its next on my TODO.

Yeah, I've been seeing that too (before and after my changes).
Haven't investigated it yet.  Good that it's on your todo list.  :-)

>> Should I just push commit 1e75540ec5202cae63cd238c86bd880e3d496546
>> ("ide-tape: remove back-to-back REQUEST_SENSE detection") to Linus
>> or there is more needed to bring ide-tape to the world of living?
> 
> ... and I'm afraid we'll have to do some serious bugfixing since this
> driver is behaving really funny :). Stay tuned, I'm on it.

Cool.

Thanks.

-- 
tejun

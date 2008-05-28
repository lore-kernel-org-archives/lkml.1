Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbYE1XrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbYE1XrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 19:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYE1XrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 19:47:11 -0400
Received: from mail.tmr.com ([64.65.253.246]:49041 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYE1XrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 19:47:10 -0400
Message-ID: <483DF1D5.9030706@tmr.com>
Date: Wed, 28 May 2008 19:59:17 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linus-IDE <linux-ide@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc4
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527120128.7074c1bc@werewolf.home>
In-Reply-To: <20080527120128.7074c1bc@werewolf.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> On Mon, 26 May 2008 11:41:35 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> You know the drill by now: another week, another -rc.
>>
>> There's a lot of small stuff in here, most people won't even notice. The 
>> most noticeable thing is for all you 32-bit x86 people who use PAE 
>> (enabled by the HIGHMEM64G config option) due to having too much memory in 
>> your machine - mprotect() was broken due to some of the PAT fix/cleanup 
>> patches, causing the NX bit to be not set correctly.
>>
>> So if you had PAE enabled _and_ a recent enough CPU to have NX, but not 
>> recent enough to be 64-bit (or you were just perverse and wanted to run a 
>> 32-bit kernel despite having a chip that could do 64-bit and enough memory 
>> that you _really_ should have used a 64-bit kernel), you'd get various 
>> random program failures with SIGSEGV. It ranged from X not starting up to 
>> apparently OpenOffice not working if it did.
>>
>> But most of the changes, as usual, are in drivers, at 60%, with some DRI 
>> changes leading the way (fixing a number of other regressions, mainly by 
>> reverting the under-cooked vblank update). Network, MMC, USB, watchdog and 
>> IDE drivers also got updates.
>>
>> We had CIFS and NFS updates, and some arch updates as usual. The dirstat 
>> gives the overview:
>>
> 
> I have this patchsets collected from LKML, that still apply ontop of -rc4.
> Are they not so urgent or are they not needed any more ?
> 
> JBD[2] races
> http://marc.info/?l=linux-ext4&m=121141319601650&w=2
> http://marc.info/?l=linux-ext4&m=121141319701660&w=2
> 
Unless I misread the thread, akpm had a raft of issues with the first 
one, all of which were spelling except one initialization which he 
thought was not needed. All of those could be fixed in less effort that 
it takes to mention them, perhaps, but even so I think the patch could 
be ready in a short time.

The problem looks worth fixing to me, but probably not a must have at 
the rc4 level. Maybe in 2.6.27 we could get rid of the potential race?


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot


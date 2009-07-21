Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbZGUGlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbZGUGlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbZGUGlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:41:39 -0400
Received: from bizon.gios.gov.pl ([195.187.34.71]:51832 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbZGUGli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:41:38 -0400
Date: Tue, 21 Jul 2009 08:40:26 +0200 (CEST)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: ole@bizon.gios.gov.pl
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Marc Dionne <marc.c.dionne@gmail.com>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LFD.2.01.0907201750150.19335@localhost.localdomain>
Message-ID: <alpine.LNX.1.10.0907210833450.29729@bizon.gios.gov.pl>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <4A650219.3060003@gmail.com> <alpine.LFD.2.01.0907201650570.19335@localhost.localdomain> <4A650DE1.20105@gmail.com> <alpine.LFD.2.01.0907201750150.19335@localhost.localdomain>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-877450442-1248158426=:29729"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-877450442-1248158426=:29729
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Mon, 20 Jul 2009, Linus Torvalds wrote:

>
>
> On Mon, 20 Jul 2009, Marc Dionne wrote:
>>>
>>> Hmm. This sounds more like the binutils bug that people had. Sounds like
>>> an assembler bug if the *.o file ends up being empty or at some fixed
>>> size. If it was cc1 that fails, I'd expect to not see an *.o file at all,
>>> since it didn't generate good assembly.
>>>
>>> In fact, your behavior sounds like the thing that produces the *.o files
>>> core-dumped or died for other reasons, and had a 64kB buffer that either
>>> got flushed or not. That would explain the "zero or exactly 64kB" size.
>>>
>>> It could be ccache too, of course.
>>
>> Actually in my case it turns out that it is ccache after all - if I remove it
>> from the picture everything is fine.  If I re-enable it, even with a clean
>> cache, I get the problem.
>>
>> It might just be a coincidence that it's triggered by the -fwrapv change.
>
> Ok, so this is getting ridiculous. Do we have _three_ different kernel
> issues going on at the same time, all subtly related to tools issues
> rather than the kernel source tree itself?
>
> That's just completely bizarre.
>
> So right now we have:
>
> - Krzysztof Oledzki: the only one who so far has really pinpointed it to
>   the -fwrapv change itself.
>
>   It would be good to really double-check that this is not about ccache,
>   since Marc apparently gets a good kernel without ccache, and -fwrapv
>   seems to be involved.

There is no ccache configured in my systems and the same problem appears 
on a different servers (both i386 and x86-64). However, the configs are 
very similar and the hardware is nearly identical.

I'm pretty sure the only different between bootable and unbootable kernel 
is that fwrapv vs strict-overflow change.

Best regards,

 				Krzysztof Olêdzki
---1144830174-877450442-1248158426=:29729--

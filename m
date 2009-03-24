Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbZCXIRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbZCXIRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbZCXIRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:17:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbZCXIRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:17:13 -0400
Date: Tue, 24 Mar 2009 09:16:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesper Krogh <jesper@krogh.cc>
Cc: David Rees <drees76@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324081659.GA9730@elte.hu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C88C80.5010803@krogh.cc>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesper Krogh <jesper@krogh.cc> wrote:

> David Rees wrote:
>> On Mon, Mar 23, 2009 at 11:19 PM, Jesper Krogh <jesper@krogh.cc> wrote:
>>> I know this has been discussed before:
>>>
>>> [129401.996244] INFO: task updatedb.mlocat:31092 blocked for more than 480
>>> seconds.
>>
>> Ouch - 480 seconds, how much memory is in that machine, and how slow
>> are the disks? 
>
> The 480 secondes is not the "wait time" but the time gone before 
> the message is printed. It the kernel-default it was earlier 120 
> seconds but thats changed by Ingo Molnar back in september. I do 
> get a lot of less noise but it really doesn't tell anything about 
> the nature of the problem.

That's true - the detector is really simple and only tries to flag 
suspiciously long uninterruptible waits. It prints out the context 
it finds but otherwise does not try to go deep about exactly why 
that delay happened.

Would you agree that the message is correct, and that there is some 
sort of "tasks wait way too long" problem on your system?

Considering:

> The systes spec:
> 32GB of memory. The disks are a Nexsan SataBeast with 42 SATA drives in  
> Raid10 connected using 4Gbit fibre-channel. I'll let it up to you to  
> decide if thats fast or slow?
[...]
> Yes, I've hit 120s+ penalties just by saving a file in vim.

i think it's fair to say that an almost 10 minutes uninterruptible 
sleep sucks to the user, by any reasonable standard. It is the year 
2009, not 1959.

The delay might be difficult to fix, but it's still reality - and 
that's the purpose of this particular debug helper: to rub reality 
under our noses, whether we like it or not.

( _My_ personal pain threshold for waiting for the computer is 
  around 1 _second_. If any command does something that i cannot
  Ctrl-C or Ctrl-Z my way out of i get annoyed. So the historic 
  limit for the hung tasks check was 10 seconds, then 60 seconds. 
  But people argued that it's too low so it was raised to 120 then 
  480 seconds. If almost 10 minutes of uninterruptible wait is still 
  acceptable then the watchdog can be turned off (because it's 
  basically pointless to run it in that case - no amount of delay 
  will be 'bad'). )

	Ingo

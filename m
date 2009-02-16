Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZBPPWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZBPPWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZBPPVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:21:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37651 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZBPPVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:21:35 -0500
Date: Mon, 16 Feb 2009 16:21:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Justin Madru <jdm64@gawab.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12263] Sata soft reset filling log
Message-ID: <20090216152111.GA31403@elte.hu>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <200902152221.43834.rjw@sisk.pl> <20090215223045.GC29300@elte.hu> <200902160012.57584.rjw@sisk.pl> <499983DF.5050503@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499983DF.5050503@ru.mvista.com>
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


* Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> Hello.
>
> Rafael J. Wysocki wrote:
>
>>>>>> This message has been generated automatically as a part of a report
>>>>>> of regressions introduced between 2.6.27 and 2.6.28.
>
>>>>>> The following bug entry is on the current list of known regressions
>>>>>> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
>>>>>> be listed and let me know (either way).
>
>>>>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12263
>>>>>> Subject		: Sata soft reset filling log
>>>>>> Submitter	: Justin Madru <bevicm@dslextreme.com>
>>>>>> Date		: 2008-12-13 2:07 (64 days old)
>>>>>> References	: http://marc.info/?l=linux-kernel&m=122913412608533&w=4
>
>>>>> I'm still seeing this on .29-rc5, and I think that my bug #12263 
>>>>> is a duplicate of bug #12609,
>>>>> or more correctly it's a duplicate of mine because I reported first.
>
>>>>> It seems like the bug has been fixed in tip/master for some time now.
>>>>> Below is the diff of origin and tip from when I tested.
>
>>>> Ingo, do you know whinch patch in -tip fixes this regression?
>
>>> This one, done on Jan 10, more than a month ago:
>
>>>  f1d26da: Revert "libata: Add 32bit PIO support"
>
>>> When a commit causes trouble in -tip qa i immediately revert it in 
>>> 95% of the cases, no questions asked. Especially if it's related to  
>>> persistent storage.
>
>> OK, thanks.
>
>> We seem to have a working fix patch for this issue in bug #12609.
>
>    Wait, if this is indeed post-2.6.27 regression, it couldn't possibly 
> have been caused by that patch which got merged during 2.6.29-rc1 
> timeframe. Something's up with this bug...

SATA uses the SCSI layer, right? It could then perhaps be these bits in 
tip:out-of-tree:

 813104e: Revert "[SCSI] simplify scsi_io_completion()"
 84db545: Revert "[SCSI] Fix uninitialized variable error in scsi_io_completion"
 0eb6038: Revert "[SCSI] Fix error handling for DIF/DIX"
 3cd94dd: Revert "[SCSI] scsi_lib: don't decrement busy counters when inserting commands"
 c27aed5: Revert "[SCSI] scsi_lib: fix DID_RESET status problems"

i needed these to keep an aic7xxx box from crashing. This regression got 
introduced at around 2.6.28-rc1, so it fits the timeframe.

	Ingo

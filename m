Return-Path: <linux-kernel-owner+w=401wt.eu-S1160998AbXEAWlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160998AbXEAWlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbXEAWlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:41:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbXEAWlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:41:47 -0400
Message-ID: <4637C227.5040108@redhat.com>
Date: Tue, 01 May 2007 18:41:43 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Michel Lespinasse <walken@zoy.org>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Jeb Cramer <cramerj@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: 24 lost ticks with 2.6.20.10 kernel
References: <20070501130715.GB29131@zoy.org> <46375E04.5030506@redhat.com> <20070501214912.GA4048@zoy.org> <4637BA70.8000108@intel.com>
In-Reply-To: <4637BA70.8000108@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Michel Lespinasse wrote:
>> (I've added the E1000 maintainers to the thread as I found the issue
>> seems to go away after I compile out that driver. For reference, I was
>> trying to figure out why I lose exactly 24 ticks about every two
>> seconds, as shown with report_lost_ticks. This is with a DQ965GF
>> motherboard with onboard E1000).
> 
> that's perfectly likely. The main issue is that we read the hardware
> stats every two seconds and that can consume quite some time. It's
> strange that you are losing that many ticks IMHO, but losing one or two
> might very well be.
> 
> We've been playing with all sorts of solutions to this problem and
> haven't come up with a way to reduce the load of the system reading HW
> stats, and it remains the most likely culprit, allthough I don't rule
> out clean routines just yet. This could very well be exaggerated at
> 100mbit speeds as well, I never looked at that.
> 
> I've had good results with 2.6.21.1 (even running tickless :)) on these
> NICs. Have you tried that yet?

Maybe this could fix it in 2.6.20? (went into 2.6.21)

--------------------------------------------------------------------------

Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=46fcc86dd71d70211e965102fb69414c90381880
Commit:     46fcc86dd71d70211e965102fb69414c90381880
Parent:     2b858bd02ffca71391161f5709588fc70da79531
Author:     Linus Torvalds <torvalds@woody.linux-foundation.org>
AuthorDate: Thu Apr 19 18:21:01 2007 -0700
Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
CommitDate: Thu Apr 19 18:21:01 2007 -0700

    Revert "e1000: fix NAPI performance on 4-port adapters"
    
    This reverts commit 60cba200f11b6f90f35634c5cd608773ae3721b7.  It's been
    linked to lockups of the e1000 hardware, see for example
    
    	https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229603
    
    but it's likely that the commit itself is not really introducing the
    bug, but just allowing an unrelated problem to rear its ugly head (ie
    one current working theory is that the code exposes us to a hardware
    race condition by decreasing the amount of time we spend in each NAPI
    poll cycle).
    
    We'll revert it until root cause is known.  Intel has a repeatable
    reproduction on two different machines and bus traces of the hardware
    doing something bad.
    


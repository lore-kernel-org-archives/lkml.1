Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbXIWDoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbXIWDoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 23:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbXIWDoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 23:44:32 -0400
Received: from smtpoutm.mac.com ([17.148.16.75]:50966 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbXIWDob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 23:44:31 -0400
In-Reply-To: <1190508441.30132.15.camel@localhost>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com> <1190506383.30132.11.camel@localhost> <BD6BFDD9-65C4-4780-BAF8-975A5A25913C@mac.com> <1190508441.30132.15.camel@localhost>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5320EF8C-B64A-4BA6-B5EB-D2AC2CC86E31@mac.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       holzheu <holzheu@linux.vnet.ibm.com>, Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [RFC] New kernel-message logging API
Date: Sat, 22 Sep 2007 23:43:36 -0400
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 22, 2007, at 20:47:21, Joe Perches wrote:
> On Sat, 2007-09-22 at 20:40 -0400, Kyle Moffett wrote:
>> Severity is *exactly* "desirability of logging".
>
> Disagree.
>
> What's info to someone is an alert to someone else.  The problem is  
> the valuation of the reasoning.
>
> It's all opinion.

For starters, I think "its all opinion" is bogus; the value of each  
log level is pretty standardly defined for the kernel:
EMERG:   The system is completely failing right NOW.  Immediate admin  
action is definitely required
ALERT:   The system is about to fail or halfway-failing.  Immediate  
admin action may be required.
ERR:     Something went badly wrong.  We are able to continue without  
endangering the overall system.
NOTICE:  Something unusual happened but it's either not a device/code  
failure or it's an expected failure.
INFO:    Something useful happened, like a device probe or a major  
system-wide event
DEBUG:   Something happened that only a developer or somebody looking  
for bugs would care about.

All of those are basically defined as: "This is how much the admin  
probably wants to see this message".  If you find a message which  
doesn't seem to match the log level it's logged at, please submit a  
patch.

Even assuming its not a bogus argument, what you actually want is  
*NOT* "Show me INFO and DEBUG, but not EMERG, ALERT, ERR, or NOTICE",  
you actually want multiple metrics by which to measure things.  We  
already have multiple ways of filtering log messages:
   1)  Log-level (greater than $LEVEL).
   2)  Userspace textual post-processing filters and classifiers (EG:  
logcheck)
   3)  CONFIG_${SUBSYS}_DEBUG and CONFIG_${DRIVER}_DEBUG

Perhaps what you want is something like the syslog "facility" parameter?

The only real reason to add more kconfig options for logging is to  
decrease the size of the kernel binary; most anything else can be  
better done in userspace in something like logcheck.  If you're going  
to add new kconfig options then you aren't going to configure them  
generically since they're inherently subsystem/driver specific.  In  
that case you might add a per-driver "CONFIG_${DRIVER}_NOLOG" for the  
drivers you care about or a "CONFIG_MAX_LOG_LEVEL" to globally limit  
by severity but any other qualifiers inherently don't fit in a single  
scalar

Cheers,
Kyle Moffett


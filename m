Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbYHFWYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbYHFWYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYHFWYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:24:05 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:33753 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbYHFWYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:24:03 -0400
X-Greylist: delayed 1188 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2008 18:24:03 EDT
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for	on
 access	scanning
Date: Wed, 6 Aug 2008 22:24:01 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <g7d8a1$81o$2@taverner.cs.berkeley.edu>
References: <20080805225524.GB4006@fieldses.org> <20080806101028.B87BA2FE88B@pmx1.sophos.com>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1218061441 8248 128.32.168.222 (6 Aug 2008 22:24:01 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Wed, 6 Aug 2008 22:24:01 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko wrote:
>J. Bruce Fields wrote on 05/08/2008 23:55:24:
>> On Mon, Aug 04, 2008 at 05:00:16PM -0400, Eric Paris wrote:
>> > There is a consensus in the security industry that protecting against
>> > malicious files (viruses, root kits, spyware, ad-ware, ...) by the way
>> > of so-called on-access scanning is usable and reasonable approach.
>> 
>> Can you point to any helpful explanations of that concensus?
>
>I can't, but everyone is doing it so that is at least an implied 
>consensus.

I don't think there is any such consensus, so I'm not expecting a
technical explanation.  As best as I can tell, the primary explanation
for why so many A/V vendors are doing it seems to be that it's a damn
effective business model, and that may have as much of an effect on its
widespread use as any technical merits or demerits.

Think about it: you get users to buy your A/V, then you tell them
they need to pay a monthly subscription fee to get the latest virus
signatures updates.  It's like crack.  Once you convince IT managers that
"every machine needs to run A/V software", it's basically a guaranteed
revenue stream for the A/V industry.  It's lucrative stuff, so it's no
surprise that the A/V industry is nursing this for as long as it can go.
And on many Microsoft platforms, the level of pain has been high enough
that IT managers are willing to accept anything that reduces the level of
pain even partially, so it's no surprise that A/V is so widely used today.
It doesn't necessarily mean that it's the right way to go for the future,
or that it's the right model for Linux, though.

>> Off-hand it's surprising.  (A defense that depends on cataloging every
>> possible individual attack sounds difficult!)

Of course.  Simple signature-based file-scanning has got deep technical
limitations.  It can detect copycats and script kiddies but you'd be
foolish to rely upon it to detect any kind of sophisticated attack.

Let's put some numbers on it, for real commercial A/V software.
I was at the Usenix Security conference last week, where one group of
researchers presented a paper that included a chart showing how quickly
McAfee A/V was able to detect new malware samples.  The researchers
collected a large set of malware samples, and ran McAfee on it once
a day or so to see how long it took for McAfee's signature database
to be updated so it could detect those malware samples.  As I recall,
the basic stats looked like this: about 30% of zero-day malware samples
were detected on the first day they were released (and 70% weren't).
The median number of days until a new malware sample was detected was
about 40 days.  If you wanted hundreds of days, asymptotically McAfee was
able to detect about 70% of the samples (and 30% were never detected).
I expect the situation to get worse in the future, not better.

And keep in mind it's easy for an attacker to write a polymorphic or
"metamorphic" virus that is basically undetectable with straightforward
signature-based file scanning, so in an arms race the attackers have
most of the advantages.

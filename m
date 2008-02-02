Return-Path: <linux-kernel-owner+w=401wt.eu-S1760924AbYBBR6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbYBBR6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 12:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYBBR6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 12:58:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39649 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYBBR6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 12:58:10 -0500
Date: Sat, 2 Feb 2008 18:57:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Message-ID: <20080202175738.GA26560@elte.hu>
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu> <47A49171.2000003@garzik.org> <20080202170828.GA12748@elte.hu> <47A4A96D.2040709@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A4A96D.2040709@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jeff Garzik <jeff@garzik.org> wrote:

> Ingo Molnar wrote:
>> it would have been totally appropriate for me to just send a mail to lkml 
>> with the proper subject line about the breakage. (I might even have 
>> decided to stay completely silent about the issue and fix it for my own 
>> build, letting you guys figure it out.)
>
> Oh come on...  You are smart enough to know to at least CC the driver 
> maintainer, the key POC who should be aware of breakage of their 
> driver.  That is a standard courtesy.

is there any particular reason why you cut out the most relevant part of 
my reply, which happens to answer all your questions AFAICS:

>> Instead i did a search of lkml (based on the function name in the 
>> build error) and figured out where the pull request was on lkml: 
>> Greg. I replied to that mail, he'll obviously know whom else to Cc 
>> from that point on (if anyone). I really didnt want to (nor did i 
>> need to) figure out whether this was some general driver level API 
>> change that happen kernel-wide, or some SCSI specific change. I 
>> simply replied to the pull request whose Cc: line seemed 
>> well-populated to me already. I also took a look at the commit itself 
>> and did a quick hack in a hurry to keep the tests rolling. It really 
>> did not occur to me that i should have added anyone else to the Cc: 
>> line, as linux-pci@atrey.karlin.mff.cuni.cz was Cc:-ed already so i 
>> assumed the interest was from that angle.

had you read this portion you'd have realized that i did not search for 
any "owner" of the file, i simply searched for the person who introduced 
the change, and the on-lkml mail where the change was introduced.

and that's all that should be needed, really. Believe me, i hit tons of 
bugs all across the kernel, often several bugs a day, and it's hard even 
for me to figure out who "maintains" a file and when. (and in Linux 
there's no "ownership" of files anyway) So as a general rule i go after 
changes instead, and that's exactly what i did here too. I do 
delta/regression QA - i.e. i watch for _changes_ that break the kernel 
and hence the general 'owner' of a file is often irrelevant - it's the 
maintainer who introduces a change who matters, and we do lots of 
cross-maintain merges. Only if i do not manage to identify a change do i 
try to figure out who maintains a file at that given moment. (But those 
mails often go into black holes, they get bounced, subscriber-required 
email lists, etc. etc.) It's also nontrivial to map the files to the 
MAINTAINERS file, and it's also quite outdated in some portions. So the 
MAINTAINERS file is the last resort i use.

so i'm still totally befuddled why you think that there was anything 
particularly wrong or unhelpful about me replying to the specific pull 
request that introduced a particular breakage into the kernel. Had i 
mailed to lkml with a terse "kernel build broke" message with just an 
URL to a config and the build breakage, you could rightfully have 
complained that i should have done more to properly direct my bugreport. 
But this breakage was about a PCI API change, the pull request had a PCI 
mailing list Cc:-ed, why should i have thought that this needs the 
attention of any other parties?

	Ingo

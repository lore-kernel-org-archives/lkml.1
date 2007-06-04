Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbXFDQxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbXFDQxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbXFDQxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:53:41 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:47449 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758865AbXFDQxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:53:40 -0400
Subject: Re: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
From: Richard Purdie <rpurdie@openedhand.com>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Woodhouse <dwmw2@infradead.org>,
       Nitin Gupta <nitingupta910@gmail.com>
In-Reply-To: <200706041214.38017.dhazelton@enter.net>
References: <1180971378.6313.72.camel@localhost.localdomain>
	 <200706041214.38017.dhazelton@enter.net>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 17:52:55 +0100
Message-Id: <1180975976.6313.133.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 12:14 -0400, Daniel Hazelton wrote:
> On Monday 04 June 2007 11:36:18 Richard Purdie wrote:
> I have been involved in benchmarking and testing that stripped down and 
> kernel-style version and cannot recall any mention of said alignment errors. 
> Perhaps I was removed from the CC: list - could you point me at them?

I've forwarded you the full mail. To quote Nitin Gupta:

> The author (Markus Oberhumer) of LZO  provided these comments for this
> patch:
[...]
> I've only briefly looked over it, but it's obvious that your version
> does not work on architechtures which do not allow unaligned access
> (arm, mips, ...).
[...]
> Still a lot to do...

So its author admits it isn't ready yet. I'm not saying that code is bad
or shouldn't be included, just that we've ascertained it isn't ready
*yet*. Which brings us back to my last mail and its proposal.

> If there *are* memory alignment issues, why not fix them in that tiny 
> code rather than pushing a different version of the code into the 
> kernel that is 
> 1) Not kernel style and 2) bloated?

The zlib code isn't kernel style and is arguably bloated, perhaps we
should remove that?

If Nitin or others can fix that patch, fine but I can't afford the time
to do it and until those issues are fixed, it isn't ready.

Also, Nitin has already claimed several times that he's made no
functional changes to that code only to find that actually there are
functional changes. That does give rise to concern (not least for
security). There are ways to address this but I don't have time to do it
so it needs someone, preferably independent who has.

> > I've trimmed my patch down to only contain the "safe" decompression
> > function, pruned the headers a little further and merged in the cleanup
> > patch I submitted to -mm previously. I've also included an updated
> > version of the patch to make resier4 use the shared LZO functions
> > (fixing a security hole in the process).
> 
> Then submit the fix for the security hole as a seperate patch to the Rieser4 
> people.

I have done and they are aware of it.

> Unless you can clearly point out those "memory alignment" issues in
> the 
> kernel-style code of the other LZO implementation that was posted as
> an RFC I 
> have to say this: stop the FUD. 

This is not FUD, I've actually done things to help the other LZO
implementation forward but my available time to help is limited.

Note that I am not the only person to have expressed concerns with the
alternative LZO implementation and some questions raised by others as
well as myself regarding some of the code differences still remain
unanswered too.

Regards,

Richard



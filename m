Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbYLDWK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbYLDWK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYLDWKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:10:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53215 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbYLDWKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:10:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Thu, 4 Dec 2008 23:01:26 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812040223.54341.rjw@sisk.pl> <alpine.LFD.2.00.0812032034150.3256@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812032034150.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812042301.26687.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 4 of December 2008, Linus Torvalds wrote:
> 
> On Thu, 4 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > Well, in principle it may be related to the way we handle bridges during
> > resume
> 
> Ahh. Yes, that's possible. It's quite possible that the problem isn't 
> resource allocation per se, but just the bigger complexity at resume time.
> 
> This is a hibernate-only issue for you, right? Or is it about regular 
> suspend-to-ram too?

It is suspend to RAM too, from what I can tell.

> > but I really need to read some docs and compare them with the code 
> > before I can say anything more about that.  Surely, nothing like this 
> > issue has ever been reported before.
> 
> Well, how stable has hibernate been on that particular machine 
> historically?
> 
> Because the half-revert alignment patch (ie reverting part of 5f17cf) that 
> made it work for you would actually have been a non-issue in the original 
> code that was pre-PCI-resource-alignment cleanup (commit 88452565).
> 
> So the patch you partially reverted was literally the one that made the 
> Cardbus allocation work the _same_ way as it did historically, before 
> 88452565. So if the new code breaks for you, then so should the "old" code 
> (ie 2.6.25 and earlier).
> 
> So the "hasn't been reported before" case may well be just another way of 
> saying "hibernate has never been very reliable".

This is a new box and the kernels earlier than 2.6.27-rc3 have not been tested
on it.  So, in fact, it's quite possible that hibernation would fail on it with
earlier kernels as well.

Thanks,
Rafael

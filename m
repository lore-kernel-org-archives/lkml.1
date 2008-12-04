Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbYLDEm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbYLDEm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYLDEmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:42:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbYLDEmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:42:16 -0500
Date: Wed, 3 Dec 2008 20:40:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812040223.54341.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812032034150.3256@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812031220.36711.rjw@sisk.pl> <alpine.LFD.2.00.0812030735230.3256@nehalem.linux-foundation.org> <200812040223.54341.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Dec 2008, Rafael J. Wysocki wrote:
> 
> Well, in principle it may be related to the way we handle bridges during
> resume

Ahh. Yes, that's possible. It's quite possible that the problem isn't 
resource allocation per se, but just the bigger complexity at resume time.

This is a hibernate-only issue for you, right? Or is it about regular 
suspend-to-ram too?

> but I really need to read some docs and compare them with the code 
> before I can say anything more about that.  Surely, nothing like this 
> issue has ever been reported before.

Well, how stable has hibernate been on that particular machine 
historically?

Because the half-revert alignment patch (ie reverting part of 5f17cf) that 
made it work for you would actually have been a non-issue in the original 
code that was pre-PCI-resource-alignment cleanup (commit 88452565).

So the patch you partially reverted was literally the one that made the 
Cardbus allocation work the _same_ way as it did historically, before 
88452565. So if the new code breaks for you, then so should the "old" code 
(ie 2.6.25 and earlier).

So the "hasn't been reported before" case may well be just another way of 
saying "hibernate has never been very reliable".

			Linus

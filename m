Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbYLFRjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbYLFRjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 12:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYLFRjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 12:39:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301AbYLFRjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 12:39:00 -0500
Date: Sat, 6 Dec 2008 09:38:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] PCI: Suspend and resume PCI Express ports with
 interrupts disabled
In-Reply-To: <200812061825.59914.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812060933430.3425@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061508.00277.rjw@sisk.pl> <alpine.LFD.2.00.0812060914100.3425@nehalem.linux-foundation.org> <200812061825.59914.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> 
> I think it should go through Jesse?

Probably correct. And we want it in -next, so that it can get some testing 
even before I open the merge window. Because I hope everybody realizes 
that there's no way we're doing this in 2.6.28, and we'll leave the broken 
and unreliable suspend.

Because afaik this is not a new bug (I tried to push a patch to do 
suspend_late/resume_early for the PCI code a _loong_ time ago, but it 
never got merged), and the only reason it showed up as a regression was 
almost certainly simply that we've always had this.

IOW, suspend/resume has always been dodgy wrt interrupts, and there's some 
luck involved. And your machine just happened to get unlucky.

I'd love to fix this in 2.6.28, but it's just not reasonable - it needs 
widespread testing with an early -rc merge. And if it turns out to fix a 
lot of machines, and there are no regressions, we can always back-port it 
later.

Jesse?

			Linus

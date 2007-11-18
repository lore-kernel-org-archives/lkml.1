Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbXKROf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbXKROf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 09:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbXKROfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 09:35:15 -0500
Received: from accolon.hansenpartnership.com ([64.109.89.108]:43399 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbXKROfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 09:35:13 -0500
Subject: Re: size of git repository (was Re: [BUG] New Kernel Bugs)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <474036EA.9040600@keyaccess.nl>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	 <20071113.033946.114918709.davem@davemloft.net>
	 <20071113034916.2556edd7.akpm@linux-foundation.org>
	 <20071113.035824.40509981.davem@davemloft.net>
	 <20071113041259.79c9a8c5.akpm@linux-foundation.org>
	 <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca>
	 <20071113164650.GA28493@elte.hu> <4739E3D0.10201@rtr.ca>
	 <20071118124404.GA4037@ucw.cz>  <474036EA.9040600@keyaccess.nl>
Content-Type: text/plain
Date: Sun, 18 Nov 2007 08:35:07 -0600
Message-Id: <1195396507.3288.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-11-18 at 13:58 +0100, Rene Herman wrote:
> On 18-11-07 13:44, Pavel Machek wrote:
> 
> > On Tue 2007-11-13 12:50:08, Mark Lord wrote:
> 
> >> It's a 540MByte download over a slow link for everyone 
> >> else.
> > 
> > Hmmm, clean-cg is 7.7G on my machine, and yes I tried
> > git-prune-packed. What am I doing wrong?
> 
> clean-cg? But failure to run "git repack -a -d" every once in a while?

Actually, the best command is 

git gc

which does a repack (into a single pack file rather than an incremenal),
and then removes all the objects now in the pack.  If, like me, you work
on temporary branches which you keep rebasing, you can add a --prune to
gc which will erase all unreferenced objects as it packs (use this one
with care.  I usually never use it but run a git prune -n just to see
what would be removed, and then run git prune separately if it looks
OK).

James



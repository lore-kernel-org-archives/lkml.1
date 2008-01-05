Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbYAEQ7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbYAEQ7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 11:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbYAEQ6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 11:58:52 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:40108 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbYAEQ6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 11:58:52 -0500
Date: Sat, 5 Jan 2008 17:58:44 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Timothy Shimmin <tes@sgi.com>
Subject: Re: Why is deleting (or reading) files not counted as IO-Wait in
	top?
Message-ID: <20080105165844.GA8874@citd.de>
References: <20080102193503.GA31414@citd.de> <20080105013115.217a5ab1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105013115.217a5ab1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.01.2008 01:31, Andrew Morton wrote:
> On Wed, 2 Jan 2008 20:35:03 +0100 Matthias Schniedermeyer <ms@citd.de> wrote:
> 
> > Hi
> > 
> > 
> > Currently i'm deleting about 500.000 files on a XFS-filesystem which 
> > takes a few minutes, as i had a top open i saw that 'wa' is shown as 
> > 0.0% (Nothing else running currently) and everything except 'id' is near 
> > the bottom too. Kernel is 2.6.23.11.
> > 
> > So, as 'rm -rf' is essentially a IO (or seek, to be more correct)-bound 
> > task, shouldn't that count as "Waiting for IO"?
> > 
> > The man-page of top says:
> > 'Amount of time the CPU has been waiting for I/O to complete.'
> > 
> > But AFAICT wa only seams to be (ac)counted for writing and not for 
> > reading. I come to that conclusion because, when i fire 'sync' i can see 
> > some percent wa for a few seconds.
> > 
> 
> Yes, you would absolutely expect `rm' to be stuck in D state and
> contributing to both load average and io-wait in this situation.
> 
> I'd think that either XFS is playing games (and it'd take some pretty
> inventive games to do this) or your observations are in error.

I don't think that i could do much wrong(tm).

rm -rf <big dir> (Took >30 minutes to delete)
Everything else was sleeping at the time.

The sleeping processes are the usual handful of about 200 processes, you 
have laying around today. 47 kernel threads, another about 40 or so 
demons, and the rest >100 processes was my KDE-Session (mostly 
'konsole's with bashes inside) with Iceweasel (Firefox) as sugar on top. 
But as i said, there weren't doing anything at all, 'us' peaked at about 
1-1.4 when i watched top.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.


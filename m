Return-Path: <linux-kernel-owner+w=401wt.eu-S932978AbXCKEON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978AbXCKEON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 23:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933014AbXCKEON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 23:14:13 -0500
Received: from waste.org ([66.93.16.53]:43860 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978AbXCKEON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 23:14:13 -0500
Date: Sat, 10 Mar 2007 22:01:32 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck@vds.kolivas.org
Subject: Re: RSDL-mm 0.28
Message-ID: <20070311040132.GS10394@waste.org>
References: <20070311013506.GD10459@waste.org> <8cd998d50703101828l71fbec7bi9a819ad7b7fd9828@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cd998d50703101828l71fbec7bi9a819ad7b7fd9828@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2007 at 01:28:22PM +1100, Con Kolivas wrote:
> >make -j 5 ccache
> > beryl    ok          good           awful
> > galeon   good        good           bad
> > mp3      good        good           bad
> > terminal good        good           bad/ok
> > mouse    good        good           bad/ok
...
> >RSDL makes most of the noyield hit back in normal make and then some
> >with ccache. Impressive. But ccache is still destroying interactivity
> >somehow. The ccache effect is fairly visible even with non-parallel
> >'make'.
> 
> Ok I don't think there's any actual accounting problem here per se
> (although I did just recently post a bugfix for rsdl however I think
> that's unrelated). What I think is going on in the ccache testcase is
> that all the work is being offloaded to kernel threads reading/writing
> to/from the filesystem and the make is not getting any actual cpu
> time.

I don't see significant system time while this is happening.

> This is "worked around" in mainline thanks to the testing for
> sleeping on uninterruptible sleep in the interactivity estimator. What
> I suspect is happening is kernel threads that are running nice -5 are
> doing all the work on make's behalf in the setting of ccache since it
> is mostly i/o bound. The reason for -nice values on kernel threads is
> questionable anyway. Can you try renicing your kernel threads all to
> nice 0 and see what effect that has? Obviously this doesn't need a
> recompile, but is simple enough to implement in kthread code as a new
> default.

Sorry, little to no benefit.

-- 
Mathematics is the supreme nostalgia of our time.

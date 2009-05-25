Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZEYVhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZEYVhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZEYVhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:37:32 -0400
Received: from mail.crca.org.au ([67.207.131.56]:54981 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbZEYVhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:37:31 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Pavel Machek <pavel@ucw.cz>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <20090525123228.GA13446@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905082144.57955.bzolnier@gmail.com>
	 <1241819971.19600.288.camel@nigel-laptop>
	 <200905090105.58243.bzolnier@gmail.com>
	 <1241824525.19600.369.camel@nigel-laptop>
	 <20090509135820.GF10859@elf.ucw.cz>
	 <1243243666.16743.64.camel@nigel-laptop>
	 <20090525123228.GA13446@elf.ucw.cz>
Content-Type: text/plain
Date: Tue, 26 May 2009 07:39:17 +1000
Message-Id: <1243287557.16743.114.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2009-05-25 at 14:32 +0200, Pavel Machek wrote:
> On Mon 2009-05-25 19:27:46, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Sat, 2009-05-09 at 15:58 +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > > Instead of new features I would rather see more effort being put into making
> > > > > the _core_ TuxOnIce (I mean patch #8 here) smaller (8 KLOC is still a lot,
> > > > > just to put things into the right perspective the current in-kernel content
> > > > > of kernel/power/ is 5.5 KLOC) and with more documentation inside the code.
> > > > 
> > > > Yeah, but those 2.5k extra lines get you more reliability and extra
> > > > functionality. They're not fat.
> > > 
> > > If you know about reliability problems in swsusp, please fix them in
> > > separate patch. Hiding the fixes in 8KLOC patch is not nice.
> > 
> > I'm going to try to. Unfortunately, they'll require what's basically a
> > group-up redesign of the basic algorithm, because to get maximum
> > reliability, you need to carefully account for the amount of storage
> > you're going to need and the amount of memory you have available, and
> > 'prepare' the image prior to doing the atomic copy.
> 
> I don't quite get it; why is that needed?
> 
> If there's not enough swap available, swsusp should freeze, realize
> there's no swap, unfreeze and continue. I do not see reliability
> problem there.

If there's not enough storage available (I'm also thinking of the file
allocator Oliver wants), freeing some memory may get you in a position
where you can hibernate. It makes sense to try to calculate how much
memory you need to free, thaw kernel threads (but not userspace), seek
to free that memory and try again - especially once we get a
shrink_all_memory replacement/rework that actually gives you what you
ask for if that's possible (that was the point to the extra code I used
to have in vmscan.c).

Regards,

Nigel


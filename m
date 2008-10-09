Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbYJIIm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbYJIIm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 04:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYJIImp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 04:42:45 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:50689 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013AbYJIImo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:42:44 -0400
Date: Thu, 9 Oct 2008 10:42:10 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Message-ID: <20081009084210.GB30258@tekkaman>
References: <1222933309-2524-3-git-send-email-giometti@linux.it> <1222933309-2524-4-git-send-email-giometti@linux.it> <1222933309-2524-5-git-send-email-giometti@linux.it> <1222933309-2524-6-git-send-email-giometti@linux.it> <1222933309-2524-7-git-send-email-giometti@linux.it> <1222933309-2524-8-git-send-email-giometti@linux.it> <1222933309-2524-9-git-send-email-giometti@linux.it> <1222933309-2524-10-git-send-email-giometti@linux.it> <1222933309-2524-11-git-send-email-giometti@linux.it> <1f1b08da0810081557u14d7b7b8p872d8454016ae8bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f1b08da0810081557u14d7b7b8p872d8454016ae8bf@mail.gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 10/10] PPS: low level IRQ timestamps recording.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 03:57:21PM -0700, john stultz wrote:

> Hey Rodolfo,
>    First of all, kudos to your persistence on this patch set, it
> really has been a long time that you've been pushing this. Hopefully
> it won't take much longer. :)

I hope so. :)

> I've never had much experience with PPS devices, so other then knowing
> a fair number of folks who are interested in using them, most of the
> code is outside of my realm of knowledge, so I've not had much to
> comment upon.
> 
> However, Thomas asked me to check and see how this interacted with the
> timekeeping subsystem, so I took another look at the current code.
> >From a quick review, I really don't see any interactions. The code
> seems fairly well isolated.
> 
> One question I have is:  Do you have any plans for integrating with
> the adjtimex() interface and its pps values?

Currently not.

> My only other comment is on this last patch #10, and as you said in
> your original post, its deferrable. I'd agree that dropping this patch
> for now would be best, since adding a getnstimeofday() call, which may
> take a few microseconds on common hardware, to every interrupt would
> be a bad idea.

I see... neither if we disable it by default in the configuration menu
and we remark in the help message that it could be dangerous? :P

However if that patch is blocking for the others then I prefere
dropping it.

> It seems having a special flag on the IRQ for timestamping would be
> better, and then we could only enable it for PPS connected interrupts.
> It may add a touch more jitter but I think it would allow for better
> performance while still reducing jitter.

It sounds good! But do you already have any idea about how to do it?
It's not an easy task since some drivers may not know at all that they
are managing a PPS device! As example, think about serial PPS devices,
they are managed by proper line discipline, so how can we modify the
IRQ handler behaviour at PPS source registration time?

> So yea. Unless there are objections from the serial and parallel port
> maintainers, or someone who has more experience with PPS devices and
> might better critique the API proposed, I see no reason for holding
> this patch set back from my (limited) perspective.

Thanks a lot for your time! I hope Linux may have this API support
soon! :)

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti

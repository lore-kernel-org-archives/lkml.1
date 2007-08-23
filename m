Return-Path: <linux-kernel-owner+w=401wt.eu-S1761672AbXHWOW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbXHWOW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932220AbXHWOWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:22:46 -0400
Received: from 1wt.eu ([62.212.114.60]:2278 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbXHWOWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:22:43 -0400
Date: Thu, 23 Aug 2007 16:08:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
Message-ID: <20070823140819.GA20646@1wt.eu>
References: <1187789765.1451.310.camel@moss-spartans.epoch.ncsc.mil> <1187790174.1451.315.camel@moss-spartans.epoch.ncsc.mil> <Xine.LNX.4.64.0708220707390.9414@us.intercode.com.au> <6bffcb0e0708220729j7b9afcf3v4edef68cc974c08d@mail.gmail.com> <Xine.LNX.4.64.0708220929370.4968@us.intercode.com.au> <6bffcb0e0708220946hc2943f5jdb33215cdfab08d1@mail.gmail.com> <6bffcb0e0708221050s68975158k7a3b27c7c30f455d@mail.gmail.com> <1187810114.1451.453.camel@moss-spartans.epoch.ncsc.mil> <20070822201634.GB14132@1wt.eu> <46CD6BF4.2080101@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CD6BF4.2080101@googlemail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 01:13:56PM +0200, Michal Piotrowski wrote:
> Willy Tarreau pisze:
> > On Wed, Aug 22, 2007 at 03:15:14PM -0400, Stephen Smalley wrote:
> >> On Wed, 2007-08-22 at 19:50 +0200, Michal Piotrowski wrote:
> >>> On 22/08/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> >>>> On 22/08/07, James Morris <jmorris@namei.org> wrote:
> >>> [snip]
> >>>>> The previous problem is theoretically unrelated.  It arose via a separate
> >>>>> mechanism which can't be used at the same as the one you're seeing now in
> >>>>> the logs.
> >>>>>
> >>>>> So this either looks like a problem which has gone unnoticed and was
> >>>>> inadvertently fixed at some point, or is unique to the 2.6.20 stable
> >>>>> series.
> >>>> Yup, it is very interesting why no one noticed it. Binary search in progress:
> >>>> good - 2.6.20.4
> >>>> bad - 2.6.20.8
> >>> Ok, I narrowed the problem to 2.6.20.7. There are a few net changes
> >>> http://eu.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20.7
> >>> any suggestions?
> >>>
> >>> I also have seen this avc on 2.6.20.6 during reboot
> >>>
> >>> [ 2333.905944] audit(1187803699.273:271): avc:  denied  { send } for
> >>> saddr=192.168.1.70 src=48591 daddr=72.14.217.189 dest=80 netif=eth0
> >>> scontext=user_u:system_r:unconfined_t:s0
> >>> tcontext=system_u:system_r:kernel_t:s0 tclass=packet
> >>> [ 2334.420598] audit(1187803699.789:272): avc:  denied  { send } for
> >>> saddr=192.168.1.70 src=47248 daddr=66.249.91.18 dest=80 netif=eth0
> >>> scontext=user_u:system_r:unconfined_t:s0
> >>> tcontext=system_u:system_r:kernel_t:s0 tclass=packet
> >>>
> >>> so the roots of the problem may lie between 2.6.20.4 and 2.6.20.6
> >>>
> >>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20.17-rc1/console2.log
> >> Might be related to this:
> >> http://marc.info/?l=git-commits-head&m=118271540932264&w=2
> > 
> > Interesting, this one was fixed in 2.6.22-rc6, but is neither in 2.6.20
> > nor in 2.6.21. Michal, could you please try to apply the patch ? I include
> > it here for your convenience. If it fixes your problem, I can queue it for
> > next 2.6.20-stable, and forward it to the -stable team for 2.6.21 in case
> > Greg and Chris plan to release another one.
> > 
> 
> I confirm that this patch fixes the problem.

Perfect, thanks for your fast feedback, it is really appreciated !
I'm queuing it for 2.6.20.18.

Regards,
Willy


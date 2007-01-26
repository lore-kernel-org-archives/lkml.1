Return-Path: <linux-kernel-owner+w=401wt.eu-S1751680AbXAZV4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbXAZV4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbXAZV4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:56:47 -0500
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:44406 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751678AbXAZV4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:56:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dCeNMCUan/jFN7esuGixx7jMP8IXE7PYoeBTAeTaWuQx2rNQ2XTcDWnoVDbwUtrFLmT8eUet/N9Be4SsWD57/1WpOBPTl2Gg5BpLcaKGcq1CKYjklbncvs/ch+OGJcSmH6biUGSX0xiT7NOQTB93s2IVBShA4TKr/AVOIJnim14=  ;
X-YMail-OSG: H35q4PsVM1lDO8hKU3PD__wByCOeikY95fkukUSFFBJCVVVwssS9e_CMyVCb4FH2l7OQ6FSxR6l7bMuFT7PocnarrzSUsL6zRywqHIXjdFutkXtkZsnzdmiXuXgjTm0-
From: David Brownell <david-b@pacbell.net>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Date: Fri, 26 Jan 2007 13:56:41 -0800
User-Agent: KMail/1.7.1
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
References: <20061219185223.GA13256@srcf.ucam.org> <20070125050009.GA8672@srcf.ucam.org> <20070126204140.GA8407@suse.de>
In-Reply-To: <20070126204140.GA8407@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701261356.42171.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 12:41 pm, Greg KH wrote:
> On Thu, Jan 25, 2007 at 05:00:09AM +0000, Matthew Garrett wrote:

> > This patch allows the bus driver to check whether a specific driver 
> > requires the split. If not, the 2.6.18 functionality is restored. It 
> > also alters feature-removals.txt to note that the deprecated 
> > functionality should not be removed until a replacement actually exists.
> 
> Ick, no.

Especially changing the feature-removal.txt file ...


> As stated before, it was broken in the past, and no userspace tools use
> it because of that.  So it was disabled.

Matthew's problem seems to be that he (?) wrote such a tool to
power down certain wireless adapters.  We did ask around, a while
back, to see if anyone was attempting to use that broken mechanism.

The only real user was pcmcia (which no longer does so), although
it was sometimes used for developer testing (with extreme caution).

Evidently that tool was written after we asked, but before anyone
got around to listing that mechanism as "gonna go"; or maybe it just
never turned up when we looked for users.


It's certainly NOT been news in the PM community, for the past
several years, that the /sys/devices/.../power/state files are
conceptually broken, so userspace tools should NOT use them.

And since the semantics of that file have never been stable even
for PCI devices (much less other busses) or even documented, I
can't have much sympathy towards software using it.

Anyone depending on unspecified behavior (a.k.a. "bugs") is
walking on thin ice.  Anyone trying to use behavior that's been
discussed (among the relevant maintainers) as broken is actively
jumping up and down on that ice.  Even though there was a gap
(sorry!) between the recognition of that mechanism as broken,
and it actually getting scheduled for removal.


> Or am I misstating that long thread?  David, your thoughts?

My recollection of that thread was that *NOBODY* claimed that a
replacement of that (broken-by-design) mechanism would ever exist.

However, there was some interesting discussion of just how to fix
the wireless adapters.  There appeared to be consensus that the
right solution involved "ifdown wlan0" (or whatever) ought to power
down that adapter, in the way Matthew wanted.

I thought the resolution was that fixing a few of those drivers
should solve the problem Matthew needed resolved, and that in
the meanwhile "rmmod drivername" should suffice.  There also seemed
to be agreement that power management for wireless devices needed
more work; there might need to be a state between "down/off" and
"configured and able to talk IP".

- Dave


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbYKDQws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbYKDQws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbYKDQtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:49:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47822 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757764AbYKDQtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:49:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git patches] libata hibernation fixes
Date: Tue, 4 Nov 2008 17:53:52 +0100
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20081104062734.GA4420@havoc.gtf.org> <alpine.LFD.2.00.0811040823350.3419@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811040823350.3419@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811041753.53342.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 4 of November 2008, Linus Torvalds wrote:
> 
> On Tue, 4 Nov 2008, Jeff Garzik wrote:
> > 
> > This adds code at a late stage (heading towards -rc4), but does
> > eliminate a particular spin-up overcycling behavior associated with
> > hibernation.
> 
> What does this have to do with hibernation? 
> 
> If it's a hibernation-only issue, then there is something wrong. 

No, it is not.  On some machines it is a power-off issue, on the others it is
hibernation and power-off issue.

> Also, if it is an issue for normal power-off as well, then I wonder why 
> this isn't an issue on Windows. Does windows not spin down disks at all?

In fact, AFAICS, it is an issue on Windows as well, at least if
other-than-HP-preloaded version of Windows is used.

> IOW, I really don't think this is correct. 
> 
> I _do_ think that correct might be:
> 
>  - maybe we just do something odd and different, triggering some BIOS 
>    behavior that isn't there under Windows.
> 
>    So we should power down thigns differently so that the BIOS.
> 
>  - quite possibly: we just should not spin down disks at all, and just 
>    flush them and do the "park" command thing. If we're _really_ powering 
>    off, the disks will spin down on their own when power goes away. Maybe 
>    that's what Windows does?
> 
> So I really don't want to pull this, because I want to get more of an 
> explanation for why we need to do this at all. I also don't think this is 
> even appropriate at this stage in -rc.
> 
> Is it a regression? If so, that just strengthens the questions above - 
> what did _we_ start doing wrong that this is needed at all? Let's just 
> stop doing that, not add some idiotic black-list for somethign that _we_ 
> do wrong.

This is a regression, but from something like 2.6.25 or even earlier.
I think what happened is we started to power-off disks at one point and these
BIOS-es just don't like that.

[Note that the issue only appears in _some_ HP boxes, other vendors don't
seem to be affected at all.]

Thanks,
Rafael

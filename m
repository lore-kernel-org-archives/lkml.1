Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYHMOqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYHMOqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYHMOqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:46:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:55676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbYHMOqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:46:42 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Power management for SCSI
Date: Wed, 13 Aug 2008 16:47:42 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       James.Bottomley@hansenpartnership.com, teheo@novell.com
References: <Pine.LNX.4.44L0.0808131026320.2455-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808131026320.2455-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808131647.43989.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 13 August 2008 16:31:03 schrieb Alan Stern:
> On Wed, 13 Aug 2008, Pavel Machek wrote:
> 
> > From: Alan Stern <stern@rowland.harvard.edu>
> > 
> > Add support for autosuspend/autoresume. Lowlevel driver can use it to
> > spin the disk down and power down its SATA link, to turn off the USB
> > interface, etc.
> > 
> > Spinning down the disk is useful - saves ~0.5W here. Powering down
> > SATA controller is even better -- should save ~1W.
> > 
> > Now, I guess the patch will need to be split to small pieces for
> > merge... I tried to rearrange it so that the documentation and hooks
> > go before stuff that needs the hooks, and before Kconfig enabler. If
> > it looks reasonably good, I'll split it into smaller pieces.
> 
> James had a number of objections to my original patch; you can read 
> them here:
> 
> https://lists.linux-foundation.org/pipermail/linux-pm/2008-March/016849.html

Very well. I see a basic problem here. For USB it is necessary that child
devices be suspended before anything higher up in the tree is suspended.
SATA seems to be able to power down a link while the device is not suspended.

In fact in true SCSI busses can be shared. So are we using the correct
approach?

	Regards
		Oliver

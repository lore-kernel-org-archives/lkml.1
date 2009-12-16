Return-Path: <linux-kernel-owner+w=401wt.eu-S935300AbZLPXWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935300AbZLPXWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933850AbZLPXWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:22:06 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:39256 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbZLPXWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:22:01 -0500
Date: Wed, 16 Dec 2009 21:21:55 -0200
From: cascardo@holoscopio.com
To: David Teigland <teigland@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       rubini@gnudd.com, gregkh@suse.de
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
Message-ID: <20091216232155.GD7791@holoscopio.com>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
 <1257813017-28598-2-git-send-email-cascardo@holoscopio.com>
 <1257813017-28598-3-git-send-email-cascardo@holoscopio.com>
 <4AF8B4FF.9050405@zytor.com>
 <20091111153632.944a255c.akpm@linux-foundation.org>
 <20091215143446.8b6a7e57.akpm@linux-foundation.org>
 <20091215233738.26188500@lxorguk.ukuu.org.uk>
 <20091216180155.GA23117@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216180155.GA23117@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 12:01:56PM -0600, David Teigland wrote:
> On Tue, Dec 15, 2009 at 11:37:38PM +0000, Alan Cox wrote:
> > > > I merged this patch, but made a note-to-self that there are remaining
> > > > open issues..
> > > 
> > > And nothing else happened.  Can we revisit this please?
> > 
> > The last I saw was a request for an explanation of the users
> > configuration and how he was getting so many misc devices. Its a bug in
> > dlm if the dlm is doing that but I didn't see any follow up to the DLM
> > folks on the subject from the reporter, so it stays NACKed and conflicts
> > with the device registry.
> 
> I never saw an indication that the dlm ate up all of someone's misc
> devices.  Can we ask the reporter what they were running?
> 

That was not such ocurrence. I don't use DLM. Sorry for all the fuss.
I've simply noticed that DLM was using misc devices to create devices
dynamically after an ioctl. I consider that that ioctl can be called as
many times as I want my userspace program to call, am I right?

> > We need to know from the DLM folks/Thaddeu what is actually going on with
> > that system, especially as it seems to be producing multiple
> > registrations of the same misc device name which is completely broken and
> > should probably be made to error anyway.
> 
> I don't believe the dlm will ever register multiple devices with the same
> name.
> 

No. That was another issue, not related to DLM at all. Again, sorry for
any confusion.

> > Whatever is going on this is the wrong "fix". If DLM should only register
> > it once (as seems the intent) then DLM needs fixing or the users config
> > or both. If it can register many then DLM needs fixing to not eat misc
> > devices.
> 
> I explained here http://lkml.org/lkml/2009/11/9/379 that the dlm does not
> use as many misc devices as has been implied.  It starts with 3, and adds
> one for each *userspace* lockspace.  There are very few applications (I
> know of 3) that create userspace lockspaces, and they each create about
> one each.
> 

The raised issue was that of the device for *each* lock. An application
could request as many as it wanted. If there's no such usecase, I don't
think that's a problem as long as that call is privileged (which may be
easily achieved with the simple chown/chmod).

> That said, I still intend to rework the dlm to use a single device for all
> lockspaces.

That would break current userspace implementations. Or do you have any
idea on solving this without this breakage?

> 
> Dave
> 

Regards and sorry for anything,
Cascardo.

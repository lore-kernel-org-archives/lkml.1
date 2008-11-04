Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYKDQaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYKDQaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbYKDQaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:30:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755501AbYKDQaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:30:00 -0500
Date: Tue, 4 Nov 2008 08:29:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
In-Reply-To: <20081104062734.GA4420@havoc.gtf.org>
Message-ID: <alpine.LFD.2.00.0811040823350.3419@nehalem.linux-foundation.org>
References: <20081104062734.GA4420@havoc.gtf.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Nov 2008, Jeff Garzik wrote:
> 
> This adds code at a late stage (heading towards -rc4), but does
> eliminate a particular spin-up overcycling behavior associated with
> hibernation.

What does this have to do with hibernation? 

If it's a hibernation-only issue, then there is something wrong. 

Also, if it is an issue for normal power-off as well, then I wonder why 
this isn't an issue on Windows. Does windows not spin down disks at all?

IOW, I really don't think this is correct. 

I _do_ think that correct might be:

 - maybe we just do something odd and different, triggering some BIOS 
   behavior that isn't there under Windows.

   So we should power down thigns differently so that the BIOS.

 - quite possibly: we just should not spin down disks at all, and just 
   flush them and do the "park" command thing. If we're _really_ powering 
   off, the disks will spin down on their own when power goes away. Maybe 
   that's what Windows does?

So I really don't want to pull this, because I want to get more of an 
explanation for why we need to do this at all. I also don't think this is 
even appropriate at this stage in -rc.

Is it a regression? If so, that just strengthens the questions above - 
what did _we_ start doing wrong that this is needed at all? Let's just 
stop doing that, not add some idiotic black-list for somethign that _we_ 
do wrong.

			Linus

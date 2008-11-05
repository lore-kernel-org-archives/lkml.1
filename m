Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbYKECm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbYKECm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 21:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYKECmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 21:42:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:46363 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbYKECmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 21:42:44 -0500
Message-ID: <49110817.60000@kernel.org>
Date: Wed, 05 Nov 2008 11:42:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <20081104062734.GA4420@havoc.gtf.org> <alpine.LFD.2.00.0811040823350.3419@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811040823350.3419@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Nov 2008 02:42:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>  - maybe we just do something odd and different, triggering some BIOS 
>    behavior that isn't there under Windows.
>    So we should power down thigns differently so that the BIOS.

These HP machines require patched storage driver to avoid the same
problem, so it's not a generic problem and Windows is doing its own
blacklisting in its own way.

>  - quite possibly: we just should not spin down disks at all, and just 
>    flush them and do the "park" command thing. If we're _really_ powering 
>    off, the disks will spin down on their own when power goes away. Maybe 
>    that's what Windows does?

I'm fairly sure they do about the same thing we do (FLUSH followed by
STANDBY_IMMEDIATE).  The only problem we've seen regarding harddrive
shutdown or suspend sequence is a BIOS wrongfully assuming the
controller is turned on and goes bonkers on suspend (this, we might want
to change, not much point in turning off all the PCI controllers before
entering suspend, is there?) and these HP machines which like to issue
STANDBY_IMMEDIATE of its own and also breaks on stock Windows.

> So I really don't want to pull this, because I want to get more of an 
> explanation for why we need to do this at all. I also don't think this is 
> even appropriate at this stage in -rc.

They were supposed to go in during -rc1 but there was a misunderstanding
while handing off patches I collected during Jeff's vacation and they
got lost inbetween.  I apologize for the late submission but this
problem can shorten life span of hard drives considerably && applies
only to a small set of machines, so I hope this can go in for 2.6.28.

> Is it a regression? If so, that just strengthens the questions above - 
> what did _we_ start doing wrong that this is needed at all? Let's just 
> stop doing that, not add some idiotic black-list for somethign that _we_ 
> do wrong.

It's a regression in a sense that a long while ago, libata didn't do any
spindown at all, which, again, was a regression from drivers/ide.  So,
the question whether this problem is a regression or not is sort of
irrelevant here.  It's plainly a ugly workaround for ugly hardware
situation and Windows does it in even uglier way.

Thanks.

-- 
tejun

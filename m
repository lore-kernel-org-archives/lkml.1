Return-Path: <linux-kernel-owner+w=401wt.eu-S1761249AbXGPFES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249AbXGPFES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXGPFEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:04:09 -0400
Received: from [212.12.190.156] ([212.12.190.156]:32850 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751972AbXGPFEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:04:08 -0400
From: Al Boldi <a1426z@gawab.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Hibernation considerations
Date: Mon, 16 Jul 2007 08:02:46 +0300
User-Agent: KMail/1.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, <david@lang.hm>
References: <Pine.LNX.4.44L0.0707151918340.30402-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707151918340.30402-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200707160802.46567.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> As for the VGA font, the effect is easy to see: Run setfont before
> hibernating; when you resume the original font will be back.  The
> kernel simply does not bother to save the VGA font information across a
> hibernate.

This could probably be handled by a device suspend/resume call; but this 
problem is not specific to kexec.

> > Ok, after applying the latest kexec patches, I was able to use the
> > kexec'd kernel to suspend to ram and resume to the normal kernel, while
> > working under a full-blown X session.  It went without a hitch.  All
> > that is needed now are the dump/restore hibernation-image routines.
>
> That's exactly my point.  While doing suspend-to-RAM from a kexec'd
> kernel may be simple, saving the hibernation image will add
> complications.

>From a kexec'd hibernation kernel pov, both S3 and S4 look conceptually 
exactly the same.  The only difference is, in S3 the memory is in memory and 
in S4 the memory is on storage.  All device handling is exactly the same, so 
if there is a problem with device handling between the kexec'd hibernation 
kernel and the normal kernel, then that would have made itself visible.

david@lang.hm wrote:
> suspend-to-RAM should not involve kexec, the only reason for doing the
> kexec to to get a seperate userspace to use for suspend-to-disk operations
> instead of trying to partially freeze the sustem and keep useing it.

Or you could do suspend-to-disk-and-RAM.  But in the above case, it was meant 
to test kexec compatibility with device suspend/resume calls.


Thanks!

--
Al


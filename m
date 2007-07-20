Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbXGTVfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbXGTVfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbXGTVe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:34:58 -0400
Received: from smtp.andrew.cmu.edu ([128.2.10.83]:42008 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbXGTVe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:34:57 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Milton Miller <miltonm@bga.com>, Ying Huang <ying.huang@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, David Lang <david@lang.hm>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
	<200707201317.58025.rjw@sisk.pl>
	<f29402c6050f9c3ff5d83a59cea2de58@bga.com>
	<200707202328.25126.rjw@sisk.pl>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Fri, 20 Jul 2007 17:33:55 -0400
In-Reply-To: <200707202328.25126.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri\, 20 Jul 2007 23\:28\:24 +0200")
Message-ID: <87ejj2pxoc.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

[snip]

>> Or add a small bit of infrastructure that errors writes at make_request 
>> if you don't have a magic "i am a direct block device write from 
>> userspace" flag on the bio.
>> 
>> The hibernate may fail, but you don't corrupt the media.
>> 
>> If you don't get the image out, resume back to the "this is resume" 
>> instead of the power-down path.

> Well, I don't think that is much prettier than the freezer ...

It seems that a better solution to the "how do we write to a file on an
in-use partition" has been suggested, which also handles swap partitions
and swap files, and does not require mounting filesystems, so it seems
that the filesystem issue need not be considered.

[snip]

> No.  I'm saying that when you go back from the image-saving kernel to the
> hibernated kernel, you need to make sure that no task will cause any
> filesystem's on-disk state to be actually updated.  If you can't make such
> a guarantee, you just can't do that.

> With the current state of the drivers, it's not doable without the
> freezer.

It seems that it should be feasible to fix the drivers so that

1. they can be taken from normal state to quiesced state without
   requiring the freezer;

2. they can be taken from normal state to low power state without
   requiring the freezer;

3. they can be taken from quiesced state to low power state without
   requiring the freezer.

In the particular, it seems that it should be possible to do (3) without
needing to schedule tasks.

It seems likely that (2) may in fact be almost exactly the same as, or
at least similar to, (1) followed by (3), at least for many drivers.
(1) is required by the kexec hibernate approach even ignoring suspend to
both or S4.  (2) is required for suspend to ram without the freezer,
which seems to be desired anyway.

[snip]

-- 
Jeremy Maitin-Shepard

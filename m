Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbXGPFS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbXGPFS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbXGPFST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:18:19 -0400
Received: from alnrmhc16.comcast.net ([204.127.225.96]:52501 "EHLO
	alnrmhc16.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbXGPFSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:18:18 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: david@lang.hm
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang\, Ying" <ying.huang@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
References: <Pine.LNX.4.44L0.0707151915570.28934-100000@netrider.rowland.org>
	<Pine.LNX.4.64.0707151650090.25614@asgard.lang.hm>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Mon, 16 Jul 2007 01:18:15 -0400
In-Reply-To: <Pine.LNX.4.64.0707151650090.25614@asgard.lang.hm>
	(david@lang.hm's message of "Sun\, 15 Jul 2007 16\:53\:47 -0700 \(PDT\)")
Message-ID: <87wsx1ylig.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

[snip]

>> Isn't is possible to avoid this problem by mounting an ext3 filesystem
>> as readonly ext2?  Provided the filesystem isn't dirty it should be
>> doable.  (And provided the filesystem doesn't use any ext3 extensions
>> that are incompatible with ext2.)

> from the last discussion I saw on the kernel mailing list, no. the act of
> mounting the ext3 filesystem as ext2 read-only will change it as the unsupported
> extentions get turned off (and I think the journal contents at least are lost as
> part of this)

The fact of the matter is that it really doesn't matter whether mounting
it read-only actually corrupts the data on disk or not.  Regardless, it
should not be done, because you are accessing a dirty filesystem that is
still in use, and consequently there are no guarantees that either the
metadata or the file contents are consistent.  It isn't necessary for
hibernation to be able to access mounted partitions anyway.

-- 
Jeremy Maitin-Shepard

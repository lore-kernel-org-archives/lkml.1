Return-Path: <linux-kernel-owner+w=401wt.eu-S935063AbXGUQOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063AbXGUQOM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 12:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761259AbXGUQOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 12:14:00 -0400
Received: from rwcrmhc15.comcast.net ([204.127.192.85]:65426 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760292AbXGUQN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 12:13:59 -0400
From: Jeremy Maitin-Shepard <jbms@cmu.edu>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, miltonm@bga.com,
       stern@rowland.harvard.edu, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: Hibernation considerations
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
	<200707202302.07116.rjw@sisk.pl>
	<E1ICDNw-0008HC-00@dorka.pomaz.szeredi.hu>
	<200707212243.35602.nigel@nigel.suspend2.net>
X-Habeas-SWE-9: mark in spam to <http://www.habeas.com/report/>.
X-Habeas-SWE-8: Message (HCM) and not spam. Please report use of this
X-Habeas-SWE-7: warrant mark warrants that this is a Habeas Compliant
X-Habeas-SWE-6: email in exchange for a license for this Habeas
X-Habeas-SWE-5: Sender Warranted Email (SWE) (tm). The sender of this
X-Habeas-SWE-4: Copyright 2002 Habeas (tm)
X-Habeas-SWE-3: like Habeas SWE (tm)
X-Habeas-SWE-2: brightly anticipated
X-Habeas-SWE-1: winter into spring
Date: Sat, 21 Jul 2007 12:13:56 -0400
In-Reply-To: <200707212243.35602.nigel@nigel.suspend2.net> (Nigel Cunningham's
	message of "Sat\, 21 Jul 2007 22\:43\:33 +1000")
Message-ID: <87lkd9ohtn.fsf@jbms.ath.cx>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that you could still potentially get a failure to freeze if one
FUSE process depends on another, and the one that is frozen second just
happens to be waiting on the one that is frozen first when it is frozen.
I admit that this situation is unlikely, and perhaps acceptable.

A larger concern is that it seems that freezing FUSE processes at all
_will_ generate deadlocks if a non-synchronous or memory-map-supporting
filesystem is loopback mounted from a FUSE filesystem.  In that case, if
you attempt to sync or free memory once FUSE is frozen, you are sure to
get a deadlock.

-- 
Jeremy Maitin-Shepard

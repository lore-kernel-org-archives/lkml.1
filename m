Return-Path: <linux-kernel-owner+w=401wt.eu-S934698AbXGQWtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934698AbXGQWtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbXGQWtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:49:13 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:49430
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370AbXGQWtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:49:12 -0400
Date: Tue, 17 Jul 2007 15:37:07 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.44L0.0707171835560.8690-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0707171535350.2467@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707171835560.8690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Alan Stern wrote:

> On Tue, 17 Jul 2007 david@lang.hm wrote:
>
>>> But what about the freezer?  The original reason for using kexec was to
>>> avoid the need for the freezer.  With no freezer, while the original
>>> kernel is busy powering down its devices, user tasks will be free to
>>> carry out I/O -- which will make the memory snapshot inconsistent with
>>> the on-disk data structures.
>>
>> no, user tasks just don't get scheduled during shutdown.
>
> But a user task may be holding a lock which is needed for putting some
> device into low-power mode.  It can't release that lock if it doesn't
> get scheduled.

then you can't suspend that box. if you schedule it, it could get another 
lock (or another process gets another lock)

if you can't power down or put hardware into low-power mode without the 
approval of userspace, you are in serious trouble.

David Lang

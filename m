Return-Path: <linux-kernel-owner+w=401wt.eu-S1764696AbXGPG4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764696AbXGPG4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 02:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXGPG4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 02:56:14 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:60997
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbXGPG4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 02:56:12 -0400
Date: Sun, 15 Jul 2007 23:49:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Al Boldi <a1426z@gawab.com>
cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Hibernation considerations
In-Reply-To: <200707160802.46567.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0707152342140.19248@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707151918340.30402-100000@netrider.rowland.org>
 <200707160802.46567.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Al Boldi wrote:

>
> david@lang.hm wrote:
>> suspend-to-RAM should not involve kexec, the only reason for doing the
>> kexec to to get a seperate userspace to use for suspend-to-disk operations
>> instead of trying to partially freeze the sustem and keep useing it.
>
> Or you could do suspend-to-disk-and-RAM.  But in the above case, it was meant
> to test kexec compatibility with device suspend/resume calls.

the point I am trying to make here is that there is no reason that the 
kexec approach needs to do _any_ suspend/resume calls.

all that is needed is the ability of the new kernel to initialize the 
devices it needs.

suspend-to-disk-and-ram could be implemented as three 
seperate steps

1. suspend-to-disk

2. resume-from-disk

3. suspend-to-ram

followed by either

4. resume-from-ram

or

4. battery dies and loptop powers off completely

5. power-on boot.

6. resume-from-disk

all that you need to do is to make sure that the system doesn't run 
anything that would affect permanent media or the outside world between 
steps #2 and #3

yes it's more steps, but each step is logicly seperate, and each step will 
be excercised on a regular basis, so the combination of the steps will 
also be reliable.

this is far better then creating yet another way to pause the system that 
only a few people will use.

David Lang

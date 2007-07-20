Return-Path: <linux-kernel-owner+w=401wt.eu-S936030AbXGTUlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936030AbXGTUlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964947AbXGTUkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:40:55 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:52105
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964937AbXGTUky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:40:54 -0400
Date: Fri, 20 Jul 2007 13:31:04 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Stern <stern@rowland.harvard.edu>
cc: Milton Miller <miltonm@bga.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ying Huang <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.44L0.0707201216460.3811-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0707201314261.5166@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707201216460.3811-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Alan Stern wrote:

> On Fri, 20 Jul 2007, Milton Miller wrote:
>
>>> We can't do this unless we have frozen tasks (this way, or another)
>>> before
>>> carrying out the entire operation.
>>
>> What can't we do?   We've already worked with the drivers to quesce the
>> hardware and put any information to resume the device in ram.  Now we
>> ask them to put their device in low power mode so we can go to sleep.
>> Even if we schedule, the only thing userspace could touch is memory.
>
> Userspace can submit I/O requests.  Someone will have to audit every
> driver to make sure that such I/O requests don't cause a quiesced
> device to become active.  If the device is active, it will make the
> memory snapshot inconsistent with the on-device data.

assuming this is the suspend-from-ram after a kexec back from the 
write-to-disk kernel I don't think you are correct.

when doing a suspend-to-ram you get to a point where you just don't use 
any userspace. from that point on you are just walking the device tree 
putting things into low-power mode. This is the point where we are talking 
about jumping to.

david Lang

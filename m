Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbXGHW23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbXGHW23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 18:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbXGHW2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 18:28:20 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:46358
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbXGHW2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 18:28:19 -0400
Date: Sun, 8 Jul 2007 15:23:45 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: hibernation/snapshot design [was Re: [PATCH] Remove process
 freezer from suspend to RAM pathway]
In-Reply-To: <20070708221315.GF5401@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0707081519210.25614@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org>
 <200707082115.27363.rjw@sisk.pl> <1183928612.3388.289.camel@localhost.localdomain>
 <200707082345.27859.rjw@sisk.pl> <1183931688.3388.316.camel@localhost.localdomain>
 <20070708221315.GF5401@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Pavel Machek wrote:

>>> Actaully, I'm perfectly fine with that, as long as each task blocked by the
>>> driver due to suspend has PF_FROZEN (or something similar) set.  Then, at
>>> least theoretically, we'll be able to drop the freezer from the suspend code
>>> path and move it after device_suspend() (or the hibernation-specific
>>> equivalent) for hibernation (in that case there shouldn't be a problem with
>>> any task waiting on I/O while the freezer is running ;-)).
>>
>> I don't see the need for a freezer for snapshot but that's a different
>> issue. (stop_machine looks good enough to me).
>
> Freezer is not needed for snapshot -- it is needed so that we can
> write out the snapshot to disk without the need for special
> drivers/block/simple-ide-for-suspend.c. (We are doing snapshot, then
> write to disk from userland code in uswsusp).

instead of trying to freeze most of the system, could you do something 
like start a virtual machine sandbox to write the data out, and not let 
any userspace other then the sandbox operate?

you would need to throw away disk buffers so that you don't mix current 
pending I/O with I/O from the sandbox, and this would be a visable change 
for how suspend is setup, but wouldn't this work?

David Lang

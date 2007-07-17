Return-Path: <linux-kernel-owner+w=401wt.eu-S934784AbXGQUk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784AbXGQUk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXGQUkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:40:06 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:53591
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbXGQUkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:40:04 -0400
Date: Tue, 17 Jul 2007 13:27:51 -0700 (PDT)
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
In-Reply-To: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Alan Stern wrote:

> On Tue, 17 Jul 2007, Rafael J. Wysocki wrote:
>
>> I'm afraid of one thing, though.
>>
>> If we create a framework without ACPI (well, ACPI needs to be enabled in the
>> kernel anyway for other reasons, like the ability to suspend to RAM) and then
>> it turns out that we have to add some ACPI hooks to it, that might be difficult
>> to do cleanly.
>>
>> Thus, it seems reasonable to think of the ACPI handling in advance.
>
> Absolutely.  This needs to be done in such a way that it will work:
>
> 	On platforms without ACPI;
>
> 	On platforms with ACPI where we do a non-ACPI type of shutdown
> 	to whatever extent it is possible (or perhaps an ACPI-aware
> 	shutdown rather than change to S4);
>
> 	On platforms with ACPI where we do an ACPI-aware transition
> 	to S4.
>
> Rafael, for those of us who aren't thoroughly familiar with all the ins
> and outs of the ACPI spec, could you please summarize a list of the
> ACPI calls needed in the second and third cases above?  Indicate which
> ones need to be done from within the original kernel and which should
> be done from within a kexec'd hibernation kernel.
>

there was just a link on slashdot toa primer on the subject of power 
management

http://www.techarp.com/showarticle.aspx?artno=420

>
> I'm still not entirely clear on how "suspend-to-both" ought to be
> handled.  Presumably it will start off as a normal hibernation.  But
> instead of shutting down, wouldn't the kexec'd kernel return to the
> original kernel?  After all, the original kernel knows about all the
> devices and can put them into a low-power state, while the kexec'd
> kernel might not have sufficient information.

this is what I'm thinking, but the issue here is that the original kernel 
needs to go into suspend-to-ram mode instead of resuming operation. per 
the e-mail I got from Ying last night this should not be hard to 
implement.

> But what about the freezer?  The original reason for using kexec was to
> avoid the need for the freezer.  With no freezer, while the original
> kernel is busy powering down its devices, user tasks will be free to
> carry out I/O -- which will make the memory snapshot inconsistent with
> the on-disk data structures.

no, user tasks just don't get scheduled during shutdown.

the big problem with the freezer isn't stopping anything from happening, 
it's _selectivly_ stopping things.

with kexec you don't need to let any portion of the origional kernel or 
userspace operate so you don't have a problem.

David Lang

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762959AbXGQHk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959AbXGQHk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXGQHks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:40:48 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:43148
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbXGQHkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:40:47 -0400
Date: Tue, 17 Jul 2007 00:34:16 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Joseph Fannin <jfannin@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: Hibernating To Swap Considered Harmful
In-Reply-To: <20070717072601.GA21633@nineveh.local>
Message-ID: <Pine.LNX.4.64.0707170030460.19248@asgard.lang.hm>
References: <200707121453.49616.rjw@sisk.pl> <87odig1idx.fsf@jbms.ath.cx>
 <20070717001239.GB20082@nineveh.local> <200707170744.08191.oliver@neukum.org>
 <20070717062803.GA9069@nineveh.local> <Pine.LNX.4.64.0707162338370.19248@asgard.lang.hm>
 <20070717072601.GA21633@nineveh.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Joseph Fannin wrote:

> On Mon, Jul 16, 2007 at 11:42:08PM -0700, david@lang.hm wrote:
>> On Tue, 17 Jul 2007, Joseph Fannin wrote:
>
>>> root is free to "dd if=/dev/random of=/dev/mem".  Root owned
>>> daemons which do bad things are bugs.
>>
>> in this case it would be more like
>>
>> dd if=/block0 of=/dev/sda1 count=1 bs=4096 skip=5000
>> dd if=/block1 of=/dev/sda1 count=1 bs=4096 skip=5050
>> dd if=/block2 of=/dev/sda1 count=1 bs=4096 skip=5400
>> etc
>>
>> to write the blocks to the raw parition in the right place
>
> What I meant by that was that root is allowed to shoot himself in the
> foot.  Nothing stops root from opening a swap/hibernate file, which
> would put it in cache, and cause it to be inconsistant if a
> hibernation image was written to it behind the kernel's back.
>
> That would be a very stupid thing to do, however.  There's no reason
> to open that file, unless you know *exactly* what you are doing, in
> which case the onus is on you to get it right.
>
> But you have a point.  The swap file could be very fragmented.  It
> might often be so, even.
>
> Still, is this better than exporting the kernel's swap internals
> (which has never been a public interface before)?
>
> Does it make the interface that writing hibernation images to swap
> imposes any better?
>
> Even if hibernation files are no less complicated to support than
> hibernating to swap files (which isn't a forgone conclusion) , there
> are plenty of reasons writing hibernation images to swap doesn't make
> sense.
>
>
>>> Again, supporting swap files (*which is not optional*) requires the
>>> very same support.
>>
>> in the kexec model why would the second kernel care about swap files at
>> all? (unles it chooses to write to them, in which case it is exactly the
>> same support, but unless it writes to them it doesn't need to care)
>
> My point is that no extra work is required to write hibernation images
> to dedicated files than to write hibernation images to swap files.
>
> If swap files are to be supported, then, there's no technical reason
> not to support dedicated hibernation files.  Dedicated hibernation
> files are better, and there's no reason not to implement them.

I agree with your point, but the reverse is not true, the ability to write 
to a dedicated hibernation file does not produce the capacity to write to 
a swap file, and I do question the 'requirement' to write the hibernation 
image to the swap file.

David Lang


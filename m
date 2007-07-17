Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbXGQGtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbXGQGtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 02:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbXGQGtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 02:49:13 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:57398
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbXGQGtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 02:49:13 -0400
Date: Mon, 16 Jul 2007 23:42:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Joseph Fannin <jfannin@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: Hibernating To Swap Considered Harmful
In-Reply-To: <20070717062803.GA9069@nineveh.local>
Message-ID: <Pine.LNX.4.64.0707162338370.19248@asgard.lang.hm>
References: <200707121453.49616.rjw@sisk.pl> <87odig1idx.fsf@jbms.ath.cx>
 <20070717001239.GB20082@nineveh.local> <200707170744.08191.oliver@neukum.org>
 <20070717062803.GA9069@nineveh.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Joseph Fannin wrote:

> On Tue, Jul 17, 2007 at 07:44:07AM +0200, Oliver Neukum wrote:
>>
>> If yoi want to go the kexec route to hibernation, the dumping kernel
>> would need to mount the filesystem to write to a file. Therefore the
>> suspending kernel would need to sync to disk and lock that file.
>
> If the file is preallocated, that's not a problem, as there's no need
> to touch filesystem metadata.  There'd need to be some channel to pass
> the disk blocks that are for writing the image, but that's not going
> to be nearly as complicated as passing the current swap data
> structures from the previous kernel.
>
> There's no reason to have that file open in the original kernel --
> it should be root-owned (it's full of privledged data) and probably
> mode 000.
>
> root is free to "dd if=/dev/random of=/dev/mem".  Root owned
> daemons which do bad things are bugs.

in this case it would be more like

dd if=/block0 of=/dev/sda1 count=1 bs=4096 skip=5000
dd if=/block1 of=/dev/sda1 count=1 bs=4096 skip=5050
dd if=/block2 of=/dev/sda1 count=1 bs=4096 skip=5400
etc

to write the blocks to the raw parition in the right place

> Again, supporting swap files (*which is not optional*) requires the
> very same support.

in the kexec model why would the second kernel care about swap files at 
all? (unles it chooses to write to them, in which case it is exactly the 
same support, but unless it writes to them it doesn't need to care)

David Lang

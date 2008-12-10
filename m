Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbYLJBgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbYLJBgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 20:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYLJBgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 20:36:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:7551 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbYLJBgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 20:36:44 -0500
Message-ID: <ac3eb2510812091736i36b47be2s59fe1a1ac6123398@mail.gmail.com>
Date: Wed, 10 Dec 2008 02:36:42 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for December 9
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       Greg <greg@kroah.com>, NeilBrown <neilb@suse.de>
In-Reply-To: <20081209173048.18382f6d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081209185237.8bb715d7.sfr@canb.auug.org.au>
	 <20081209153418.4628723d.akpm@linux-foundation.org>
	 <ac3eb2510812091606k5615135fn87d35aaa16834ea8@mail.gmail.com>
	 <20081209161511.15fe8cdb.akpm@linux-foundation.org>
	 <ac3eb2510812091631j3b350ac6t9429e01171a96228@mail.gmail.com>
	 <20081209173048.18382f6d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 02:30, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 10 Dec 2008 01:31:13 +0100 "Kay Sievers" <kay.sievers@vrfy.org> wrote:
>
>> > akpm2:/home/akpm# udevmonitor
>> > udevmonitor prints the received event from the kernel [UEVENT]
>> > and the event which udev sends out after rule processing [UDEV]
>> >
>> > UDEV  [1228867146.103334] add@/class/bdi/9:0
>> > UDEV  [1228867146.107566] remove@/block/md0
>> > UDEV  [1228867146.111969] remove@/class/bdi/9:0
>> > UEVENT[1228867146.119889] add@/block/md0
>> > UEVENT[1228867146.119964] add@/class/bdi/9:0
>> > UEVENT[1228867146.120162] remove@/class/bdi/9:0
>> > UEVENT[1228867146.120205] remove@/block/md0
>> > UDEV  [1228867146.122839] add@/block/md0
>> > UDEV  [1228867146.129125] add@/class/bdi/9:0
>> > UDEV  [1228867146.133459] remove@/block/md0
>> > UDEV  [1228867146.137813] remove@/class/bdi/9:0
>> > UEVENT[1228867146.145652] add@/block/md0
>>
>> Weird loop, something is accessing /dev/md0, i guess, which creates
>> the kernel device, and the event, which accesses /dev/md0 again and it
>> goes crazy. Maybe caused by changes Neil did.
>
> I knew an Australian was to blame - it's just a matter of determining
> which one.

I added him alredy to Cc: with the last mail. :)

I guess it's something like this:
  http://neil.brown.name/git?p=md;a=commitdiff;h=6ac9b8824fd2f82fff508eecc5c74cf797e93cb2

I really hope we can fix that change, as we want to have proper
lifetime rules like this, where the devices, which are not used, do
not show up.

>> Do you use md devices on that box?
>
> Nope.

Fine.

Kay

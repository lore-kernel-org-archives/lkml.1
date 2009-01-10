Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbZAJGSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbZAJGSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZAJGSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 01:18:44 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:45442 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbZAJGSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 01:18:43 -0500
MIME-Version: 1.0
In-Reply-To: <adahc47ofl5.fsf@cisco.com>
References: <adaljtjog90.fsf@cisco.com>
	 <ac3eb2510901092208q1bbaca38xc1aefa9247b86f42@mail.gmail.com>
	 <adahc47ofl5.fsf@cisco.com>
Date: Sat, 10 Jan 2009 07:18:41 +0100
Message-ID: <ac3eb2510901092218v789654f3o382441169c4101bf@mail.gmail.com>
Subject: Re: [PATCH] block: Fix register_disk() when name has '/' in it
From: Kay Sievers <kay.sievers@vrfy.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 07:11, Roland Dreier <rdreier@cisco.com> wrote:
>  > > Commit 3ada8b7e ("block: struct device - replace bus_id with dev_name(),
>  > > dev_set_name()") deleted the code in register_disk() that changed a '/'
>  > > to a '!' in the device name when registering a disk.
>  >
>  > Hmm, this is done in the core, for all devices since a while:
>  >   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9f255651fb41c111ee35a2ae632df8ce9bd61def
>  >
>  > We should find what is going wrong here, instead of putting that code back.
>
> The commit you point to is for kobject_set_name() ... but dev_set_name()
> is still just setting dev->bus_id (at least in Linus's current tree).

Ah, right, it will only work after dev_name() returns the kobject
name, which it already does with the patches in our queue, so we
missed that. Sorry.

> If you want I can send a patch putting the conversion into
> dev_set_name() for now instead.

Sounds good, we can remove that with the final conversion and the
removal of the bus_id field.

Thanks,
Kay

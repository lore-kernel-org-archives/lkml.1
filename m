Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbZCZRZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbZCZRZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758399AbZCZRZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:25:30 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:42237 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583AbZCZRZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:25:28 -0400
MIME-Version: 1.0
In-Reply-To: <20090326144716.GA5696@nostromo.devel.redhat.com>
References: <1238007647-25752-1-git-send-email-notting@redhat.com>
	 <20090325190137.GA8509@infradead.org>
	 <20090325190321.GB25176@nostromo.devel.redhat.com>
	 <20090325192653.GS14127@parisc-linux.org>
	 <20090325194756.GA26465@nostromo.devel.redhat.com>
	 <20090325203624.GT14127@parisc-linux.org>
	 <20090326144716.GA5696@nostromo.devel.redhat.com>
Date: Thu, 26 Mar 2009 18:25:25 +0100
Message-ID: <ac3eb2510903261025y5cacc8a3i32ba8ee8896c9db9@mail.gmail.com>
Subject: Re: [PATCH] Add a 'wait-scan' command to /proc/scsi/scsi.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       pjones@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 15:47, Bill Nottingham <notting@redhat.com> wrote:
> Matthew Wilcox (matthew@wil.cx) said:

>> > Well, in the case I'm looking at, udev is what's loading the host
>> > controllers, and there needs to be some sort of synchronization point
>> > between that and LVM invocations, fsck, mount, etc. Since scans
>> > aren't sent over as events for udev to catch, 'udevadm settle'
>> > isn't enough.
>>
>> So ... if we sent a udev event when the scan list was empty, you'd be OK?
>
> I'm CC'ing Peter, who has some more ideas - it would definitely be a good
> start, but we'd probably at least need to know when the scan list started
> being filled as well.

I don't like to see any uevent send for issues like this. This would
just be a hack around badly designed system services, which should be
fixed themselves and not worked around in the kernel. This hack will
run useless events for system who don't need them.

Something like a poll()'able sysfs file, which other subsytems already
use, and which can be used to wake up a process that can blocks, might
work fine here.

Thanks,
Kay

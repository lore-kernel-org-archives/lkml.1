Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab0CDROa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:14:30 -0500
Received: from tenax.loup.net ([209.169.16.66]:49135 "EHLO tenax.loup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab0CDRO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:14:29 -0500
X-Greylist: delayed 1413 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2010 12:14:28 EST
Date: Thu, 4 Mar 2010 09:31:47 -0700
Message-Id: <201003041631.o24GVl51005720@alien.loup.net>
From: Mike Hayward <hayward@loup.net>
To: foosaa@gmail.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-mm@kvack.org
In-reply-to: <f875e2fe1003040458o3e13de97v3d839482939b687b@mail.gmail.com>
	(message from foo saa on Thu, 4 Mar 2010 07:58:07 -0500)
Subject: Re: Linux kernel - Libata bad block error handling to user mode 
	program
References: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
	 <20100303224245.ae8d1f7a.akpm@linux-foundation.org> <f875e2fe1003040458o3e13de97v3d839482939b687b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have seen a couple of your posts on this and thought I'd chime in
since I know a bit about storage.

I frequently see io errors come through to user space (both read and
write requests) from usb flash drives, so there is a functioning error
path there to some degree.  When I see the errors, the kernel is also
logging the sector and eventually resetting the device.

There is no doubt a disk drive will slow down when it hits a bad spot
since it will retry numerous times, most likely trying to remap bad
blocks.  Of course your write succeeded because you probably have the
drive cache enabled.  Flush or a full cache hangs while the drive
retries all of the sectors that are bad, remapping them until finally
it can remap no more.  At some point it probably returns an error if
flush is timing out or it can't remap any more sectors, but it won't
include the bad sector.

I would suggest turning the drive cache off.  Then the drive won't lie
to you about completing writes and you'll at least know which sectors
are bad.  Just a thought :-)

- Mike

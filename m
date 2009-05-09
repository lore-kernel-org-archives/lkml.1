Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbZEIRCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbZEIRCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 13:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZEIRC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 13:02:27 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:39107 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZEIRC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 13:02:26 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0905081000140.3010-100000@iolanthe.rowland.org>
References: <ac3eb2510905071612v61a27760hffc684ee87df9249@mail.gmail.com> 
	<Pine.LNX.4.44L0.0905081000140.3010-100000@iolanthe.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 9 May 2009 19:00:47 +0200
Message-ID: <ac3eb2510905091000y4c7a6448uce799d00d500fffe@mail.gmail.com>
Subject: Re: usbfs, claiming entire usb devices
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 8, 2009 at 16:06, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 8 May 2009, Kay Sievers wrote:
>
>> You mentioned earlier, that you would need to match the holder of the
>> "lock" and the one that accesses the device?
>
> Yes.  That is, a process shouldn't be allowed to access a locked device
> unless that process is the lock holder.

You think the pid or the uid would make more sense?

>> Wouldn't it be sufficient already, if you can take a "lock" at the
>> specific port, that prevents the kernel to access the device when it
>> shows up?
>
> I don't know how the people requesting this feature would feel about
> that.  They seem to want to lock out other processes as well as locking
> out the kernel.

Might be useful, yeah. I could think of use cases where a specific uid
wants to lock a device, by holding the lock file open, and only the
same uid (could be a different pid) can claim the device from
userspace.

>> You thought of supporting a number of different users, with different
>> uids, or would that be a root-only action?
>
> A typical use case would be somebody running an emulator like QEMU.  In
> theory there could be multiple QEMU processes running concurrently,
> each owning a different set of ports.  The uids might be different or
> they might all be the same.
>
> Setting the lock permissions would be up to userspace.

Yeah, sounds fine.

Kay

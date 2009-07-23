Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZGWPL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZGWPL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 11:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZGWPL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 11:11:28 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:16160 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbZGWPL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:11:27 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0907231042040.2825-100000@iolanthe.rowland.org>
References: <20090723012140.39f697d2.akpm@linux-foundation.org> 
	<Pine.LNX.4.44L0.0907231042040.2825-100000@iolanthe.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 23 Jul 2009 17:11:12 +0200
Message-ID: <ac3eb2510907230811q35c7561qb7f67979cc9953af@mail.gmail.com>
Subject: Re: 2.6.31-rc3: replugging USB serial converter uses new device node
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ferenc Wagner <wferi@niif.hu>,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 16:44, Alan Stern<stern@rowland.harvard.edu> wrote:
> On Thu, 23 Jul 2009, Andrew Morton wrote:
>> On Sat, 18 Jul 2009 22:04:57 +0200 Ferenc Wagner <wferi@niif.hu> wrote:

>> > Since upgrading to 2.6.31-rc3 from 2.6.30, my ttyUSB device number
>> > keeps increasing on each replug.  Output of udevadm monitor:
> ...
>> > Dmesg is available at http://pastebin.com/d516e3e00.
>>
>> Can anyone say whether this is expected behaviour?
>
> It depends on whether a program is still holding the old device file
> open when the replug occurs.
>
>> Does it actually cause any observeable problems?  I expect things will
>> get ugly once it runs out of range.
>
> The numbers will get reused after the corresponding device files are
> closed.

You might find a symlink for ttyUSB devices to the actual device node,
which does not depend on the kernel name, in:
  /dev/serial/
  |-- by-id
  |   `-- usb-067b_2303-if00-port0 -> ../../ttyUSB0
  `-- by-path
      `-- pci-0000:00:1d.7-usb-0:1.1.3.2:1.0-port0 -> ../../ttyUSB0

> For further discussion, see this thread:
>
>        http://marc.info/?t=124828810800002&r=1&w=2

I can't find the original message to reply, but the device node is
always deleted and re-created when the device goes away and comes
back.

Thanks,
Kay

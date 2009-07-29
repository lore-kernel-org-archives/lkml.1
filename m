Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZG2VgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZG2VgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZG2VgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:36:22 -0400
Received: from mail.lang.hm ([64.81.33.126]:46834 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbZG2VgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:36:21 -0400
Date: Wed, 29 Jul 2009 14:35:57 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk
Subject: Re: [Security] Should open TTY device files pin minor numbers?
In-Reply-To: <4A70BD33.808@zytor.com>
Message-ID: <alpine.DEB.1.10.0907291434520.28013@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0907231421390.3509-100000@iolanthe.rowland.org> <20090725051434.GD19432@kroah.com> <4A70BD33.808@zytor.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009, H. Peter Anvin wrote:

> On 07/24/2009 10:14 PM, Greg KH wrote:
>> On Thu, Jul 23, 2009 at 02:38:01PM -0400, Alan Stern wrote:
>>> Recent work in the TTY core and in usb-serial has caused a change
>>> in behavior between 2.6.30 and 2.6.31-rc.  Namely, if a USB serial
>>> device is unplugged while a process holds the device file open, the
>>> minor number won't get reused until the process closes the file.
>>
>> That's how the usb-serial code always worked, this is nothing new at
>> all.
>>
>>> For example, if you run minicom over /dev/ttyUSB0, unplug the USB
>>> device while minicom is running, and then plug it in again before
>>> exiting minicom, it will reappear as /dev/ttyUSB1 instead of
>>> /dev/ttyUSB0 (which will be gone).
>>
>> Exactly.  People are used to this by now, it shouldn't be a supprise :)
>>
>
> It is, however, a *very* nasty surprise when the USB bus glitches.

however since the serial adapters will be re-detected in a random order 
it's less nasty than cross-connecting devices and applications silently.

David Lang

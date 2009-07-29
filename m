Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbZG2VVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbZG2VVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZG2VVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:21:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43243 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbZG2VVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:21:11 -0400
Message-ID: <4A70BD33.808@zytor.com>
Date: Wed, 29 Jul 2009 14:20:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk
Subject: Re: [Security] Should open TTY device files pin minor numbers?
References: <Pine.LNX.4.44L0.0907231421390.3509-100000@iolanthe.rowland.org> <20090725051434.GD19432@kroah.com>
In-Reply-To: <20090725051434.GD19432@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2009 10:14 PM, Greg KH wrote:
> On Thu, Jul 23, 2009 at 02:38:01PM -0400, Alan Stern wrote:
>> Recent work in the TTY core and in usb-serial has caused a change 
>> in behavior between 2.6.30 and 2.6.31-rc.  Namely, if a USB serial 
>> device is unplugged while a process holds the device file open, the 
>> minor number won't get reused until the process closes the file.
> 
> That's how the usb-serial code always worked, this is nothing new at
> all.
> 
>> For example, if you run minicom over /dev/ttyUSB0, unplug the USB
>> device while minicom is running, and then plug it in again before
>> exiting minicom, it will reappear as /dev/ttyUSB1 instead of
>> /dev/ttyUSB0 (which will be gone).
> 
> Exactly.  People are used to this by now, it shouldn't be a supprise :)
> 

It is, however, a *very* nasty surprise when the USB bus glitches.

	-hpa

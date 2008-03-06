Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbYCFMeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbYCFMeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbYCFMe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:34:29 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:25720 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754450AbYCFMe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:34:28 -0500
X-Trace: 672893876/mk-filter-1.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAMJzz0dRAVlC/2dsb2JhbACBVqo0
Message-ID: <8031.85.118.17.158.1204806681.squirrel@newgolddream.dyndns.info>
In-Reply-To: <20080305234653.GA5904@kroah.com>
References: <8b67d60803051525g3aca775dmc14d1c2450b34168@mail.gmail.com>
    <20080305234653.GA5904@kroah.com>
Date: Thu, 6 Mar 2008 12:31:21 -0000 (UTC)
Subject: Re: Behaviour of device_register
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Greg KH" <greg@kroah.com>
Cc: "Adrian McMenamin" <lkmladrian@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "linux-sh" <linux-sh@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, March 5, 2008 11:46 pm, Greg KH wrote:
> On Wed, Mar 05, 2008 at 11:25:48PM +0000, Adrian McMenamin wrote:
>> The observed behaviour for me is that it appears to be blocking the
>> vblank interrupt on my box (or more accurately stopping the workqueue
>> that the interrupt handler calls from running). And without the vblank
>> my bus won't process dma and so therefore the attempt to register the
>> device in question fails.
>>
>> But I can see no reason from a glance over the code why that (vblanks
>> being blocked) would be the case - have I missed something and the
>> vblanks will be blocked, or should I be looking elsewhere for the root
>> cause of this problem?
>
> device_register(), on it's own, does not touch any hardware, nor prevent
> anything else in the kernel from happening.
>
> So I think you need to look elsewhere, like into the bus that is doing
> the device_register() call :)
>


It turns out this is a lock contention issue.

The code blocks waiting for a lock that will never be freed.


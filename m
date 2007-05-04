Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbXEDCFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbXEDCFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 22:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbXEDCFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 22:05:36 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:34163
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbXEDCFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 22:05:35 -0400
Message-ID: <463AA2F5.7030307@microgate.com>
Date: Thu, 03 May 2007 21:05:25 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tty add compat_ioctl
References: <1178213683.4369.3.camel@amdx2.microgate.com> <200705040223.46326.arnd@arndb.de> <463A8FF9.3080607@microgate.com>
In-Reply-To: <463A8FF9.3080607@microgate.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Fulghum wrote:
> Arnd Bergmann wrote:
>> - In your driver you don't get the big kernel lock in the 
>> compat_ioctl function. I assume that this is correct for
>> the particular driver, but it may be nice if you could
>> consequently also add an unlocked_ioctl function that can
>> be used without the BKL for native ioctls. It would be good
>> to hear an opinon on this from someone who has an insight
>> in tty locking issues though, so I'm Cc:ing some people
>> who have touched that recently.
> 
> I don't count on higher level locking for
> synchronization issues specific to the driver.
> 
> I thought the current compat_ioctl() was already
> meant to *not* have the BKL just like unlocked_ioctl.
> My thought was that any driver getting a recent update
> like compat_ioctl() would need to be reviewed for BKL
> safety and take the lock manually if necessary.

Nevermind. I misread what you wrote (I'm tired).
Yes, adding an unlocked_ioctl() makes sense.

--
Paul


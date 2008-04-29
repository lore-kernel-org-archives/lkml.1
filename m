Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYD2EhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYD2EhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 00:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYD2EhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 00:37:03 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:23031 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYD2EhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 00:37:01 -0400
Message-ID: <4816A5EB.5090402@msgid.tls.msk.ru>
Date: Tue, 29 Apr 2008 08:36:59 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080406)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: umount(/proc) after CLONE_NEWNS in 2.6.25?
References: <481609A5.1080905@msgid.tls.msk.ru> <20080428182759.GF5882@ZenIV.linux.org.uk> <20080429014718.GI5882@ZenIV.linux.org.uk> <20080429020638.GJ5882@ZenIV.linux.org.uk> <20080429021228.GK5882@ZenIV.linux.org.uk>
In-Reply-To: <20080429021228.GK5882@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Apr 29, 2008 at 03:06:38AM +0100, Al Viro wrote:
> 
>>> Check the version of umount(8) you've got.  And see if that strace happens
>>> to have open of /proc/mounts, without matching close by the time it calls
>>> umount().  util-linux-ng 2.13.1 is _that_ dumb...
>> Umm...  Looks like something more odd is going on...
> 
> ... or something much simpler:
> 
> ; cat /proc/mounts |grep proc
> proc /proc proc rw,nosuid,nodev,noexec 0 0
> usbfs /proc/bus/usb usbfs rw 0 0
> ;
> 
> and unmounting the stuff mounted under /proc before doing umount /proc
> works as expected.  Amazing how well the first cup of coffee helps...

Hey.  Don't paint ME *that* dumb... ;)

It was indeed the case here.  I never tried those things on my
home machine before, and decided to experiment, but I forgot
that it has /proc/bus/usb mounted.  And for comparison I used
another machine which does NOT have that filesystem mounted.
How.. dum^Wodd... ;)

Please excuse me for the noise.

/mj

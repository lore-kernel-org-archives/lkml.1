Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0CCIfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 03:35:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53410 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab0CCIfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 03:35:14 -0500
Message-ID: <4B8E1F34.7030604@zytor.com>
Date: Wed, 03 Mar 2010 00:35:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] init: Open /dev/console from rootfs
References: <m1sk8hn8nk.fsf@fess.ebiederm.org>
In-Reply-To: <m1sk8hn8nk.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2010 11:53 PM, Eric W. Biederman wrote:
> 
> To avoid potential problems with an empty /dev open /dev/console
> from rootfs instead of waiting to mount our root filesystem and
> mounting it there.   This effectively guarantees that there will
> be a device node, and it won't be on a filesystem that we will
> ever unmount, so there are no issues with leaving /dev/console
> open and pinning the filesystem.
> 
> This is actually more effective than automatically mounting
> devtmpfs on /dev because it removes removes the occasionally
> problematic assumption that /dev/console exists from the boot
> code.
> 
> With this patch I was able to throw busybox on my /boot partition
> (which has no /dev directory) and boot into userspace without
> problems.
> 
> The only possible negative consequence I can think of is that
> someone out there deliberately used did not use a character device
> that is major 5 minor 2 for /dev/console.  Does anyone know of a
> situation in which that could make sense?
> 

There probably are ... but if so, they can just re-open their new
console of choice after creating it, and/or use an initramfs which
overrides the default /dev/console.

As such, this makes a lot of sense to me.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


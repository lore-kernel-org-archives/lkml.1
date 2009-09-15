Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbZIOOIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbZIOOIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZIOOIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:08:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbZIOOId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:08:33 -0400
Message-ID: <4AAF9FD8.1010008@redhat.com>
Date: Tue, 15 Sep 2009 16:08:24 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Amit Shah <amit.shah@redhat.com>, Alan Cox <alan@linux.intel.com>,
       rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic
 guest and host communication
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com> <20090915123752.GB5247@amit-x200.redhat.com> <4AAF8F26.8030503@codemonkey.ws>
In-Reply-To: <4AAF8F26.8030503@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/09 14:57, Anthony Liguori wrote:
> That's probably not what we want. I imagine what we want is:
>
> /dev/ttyV0
> /dev/ttyV1
> /dev/ttyVN

Yes.

> And then we want:
>
> /sys/class/virtio-console/ttyV0/name -> "org.qemu.clipboard"

Yes.

> Userspace can detect when new virtio-consoles appear via udev events.
> When it sees a new ttyVN, it can then look in sysfs to discover it's name.

No.  udev can create symlinks for you, so apps don't have to dig into 
sysfs.  You'll need a rule along the lines (untested):

    SUBSYSTEM=="virtio", \
    DRIVERS="virtio-console", \
    SYMLINK+="vcon/$attr{name}"

then udev will create a /dev/vcon/org.qemu.clipboard symlink pointing to 
dev/ttyV0.  Apps can just open /dev/vcon/$name then.

cheers,
   Gerd


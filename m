Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZIOM5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZIOM5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 08:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZIOM5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 08:57:15 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:55765 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbZIOM5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 08:57:14 -0400
Message-ID: <4AAF8F26.8030503@codemonkey.ws>
Date: Tue, 15 Sep 2009 07:57:10 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
CC: Alan Cox <alan@linux.intel.com>, rusty@rustcorp.com.au,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic
 guest and host communication
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com> <20090915123752.GB5247@amit-x200.redhat.com>
In-Reply-To: <20090915123752.GB5247@amit-x200.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah wrote:
> Hey Greg,
>
> Can you tell me how this could work out -- each console port could have
> a "role" string associated with it (obtainable from the invoking qemu
> process in case of qemu/kvm). Something that I have in mind currently
> is:
>
> $ qemu-kvm ... -virtioconsole role=org/qemu/clipboard
>
> and then the guest kernel sees the string, and puts the
> "org/qemu/clipboard" in some file in sysfs. Guest userspace should then
> be able to open and read/write to
>
> /dev/virtio_console/org/qemu/clipboard
>   

That's probably not what we want.  I imagine what we want is:

/dev/ttyV0
/dev/ttyV1
/dev/ttyVN

And then we want:

/sys/class/virtio-console/ttyV0/name -> "org.qemu.clipboard"

Userspace can detect when new virtio-consoles appear via udev events.  
When it sees a new ttyVN, it can then look in sysfs to discover it's name.

Regards,

Anthony Liguori

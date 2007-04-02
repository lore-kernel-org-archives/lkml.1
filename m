Return-Path: <linux-kernel-owner+w=401wt.eu-S965537AbXDBOtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537AbXDBOtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965533AbXDBOtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:49:13 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:3208 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965539AbXDBOtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:49:12 -0400
Message-ID: <461117E4.3060504@rtr.ca>
Date: Mon, 02 Apr 2007 10:49:08 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: David Zeuthen <davidz@redhat.com>, Maxim <maximlevitsky@gmail.com>,
       Pete Zaitcev <zaitcev@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
References: <200703271824.46804.maximlevitsky@gmail.com> <Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org> <20070327110524.975e7113.zaitcev@redhat.com> <200703280129.10197.maximlevitsky@gmail.com> <20070401152957.GA5068@ucw.cz> <1175449366.3008.120.camel@zelda.fubar.dk> <20070401175020.GE11146@elf.ucw.cz>
In-Reply-To: <20070401175020.GE11146@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> ..
> Problem is that suspending _with_ removable mass storage devices
> attached just will not work. User will unplug them, then complain
> about corruption. Advanced user will unplug them, work with them
> somewhere else, replug them, then loose filesystem.
> 
> Feel free to send patch to teach filesystems to handle this.

People have already fixed this:  sync() before suspend,
and use a journalling filesystem.  Problem solved.

And when the rootfs is on an external drive, this is the *only* option.

So let's make it work (again, like it used to work!).

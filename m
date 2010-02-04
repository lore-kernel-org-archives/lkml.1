Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab0BDLND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 06:13:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52209 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755403Ab0BDLNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 06:13:00 -0500
Date: Thu, 4 Feb 2010 11:13:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: vb@vsbe.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: associating miscdevice with inode
Message-ID: <20100204111337.0c474c94@lxorguk.ukuu.org.uk>
In-Reply-To: <f608b67d1002032224r74450689ge416382a1db8e4cf@mail.gmail.com>
References: <f608b67d1002032224r74450689ge416382a1db8e4cf@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 22:24:46 -0800
vb@vsbe.com wrote:

> guys,
> 
> say I have a misc device driver which instantiates several devices.
> When a file operation on this device is invoked, I need to be able to
> figure out which device is being accessed. All available information
> are
> 
> struct inode and struct file. Is there a way to find the address of
> the miscdevice structure passed to misc_register() when this device
> was created?

Not really. If you have a single misc device which each open creates a
new context of some sort then use filp->private_data to store your own
cotntext pointer.

Misc doesn't expect people to be registering lots of devices - its for
one offs and weirdnesses. You could I guess work backwards from

	minor = iminor(inode);

and see which of your miscdevs has c->minor == minor.

If you have more than a couple of instances being put into misc you
should probably register an anonymous device major/minor range instead
and go direct.

Alan

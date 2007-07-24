Return-Path: <linux-kernel-owner+w=401wt.eu-S1762660AbXGXH0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762660AbXGXH0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbXGXH0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:26:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbXGXH0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:26:23 -0400
Date: Tue, 24 Jul 2007 00:25:40 -0700
From: Greg KH <gregkh@suse.de>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cornelia.huck@de.ibm.com
Subject: Re: sysfs/udev broken in latest git?
Message-ID: <20070724072540.GA835@suse.de>
References: <46A59EAA.9030105@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A59EAA.9030105@simon.arlott.org.uk>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 07:39:38AM +0100, Simon Arlott wrote:
> The following commit appears to break some of my udev rules (I don't 
> have the time to finish the bisect right now, but there's only four 
> changes showing in "git bisect visualize" - this one is tagged 
> bisect/bad, and the other three are docs/docs/unrelated).
> 
> Neither of these symlinks get created by udev on kernels marked bad 
> (see bisect log below):
> 
> ACTION=="add", \
>         KERNEL=="event*", \
>         SUBSYSTEM=="input", \
>         SYSFS{description}=="i8042 KBD port", \
>         NAME="input/%k", \
>         SYMLINK="input/i8042-kbd", \
>         MODE="0640", \
>         GROUP="event"
> 
> ACTION=="add", \
>         KERNEL=="event*", \
>         SUBSYSTEM=="input", \
>         SYSFS{manufacturer}=="Logitech", \
>         SYSFS{product}=="USB-PS/2 Optical Mouse", \
>         NAME="input/%k", \
>         SYMLINK="input/logitech-mouse", \
>         MODE="0640", \
>         GROUP="event"
> 
> Author: Cornelia Huck <cornelia.huck@de.ibm.com>  2007-07-18 09:43:47
> Committer: Greg Kroah-Hartman <gregkh@suse.de>  2007-07-18 23:49:50
> Parent: be3884943674f8ee7656b1d8b71c087ec900c836 (HOWTO: Add the knwon_regression URI to the documentation)
> 
>     Driver core: check return code of sysfs_create_link()
>     
>     Check for return value of sysfs_create_link() in device_add() and
>     device_rename().  Add helper functions device_add_class_symlinks() and
>     device_remove_class_symlinks() to make the code easier to read.
>     
>     [akpm@linux-foundation.org: fix unused var warnings]
>     
>     Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
>     Acked-by: Jeff Garzik <jeff@garzik.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Ugh, I thought this was all fixed up properly :(

Cornelia, can you work to figure this out?

thanks,

greg k-h

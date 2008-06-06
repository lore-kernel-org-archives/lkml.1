Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbYFFOjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbYFFOjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbYFFOjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:39:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40031 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752137AbYFFOjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:39:23 -0400
Date: Fri, 6 Jun 2008 10:39:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@suse.cz>
cc: gregkh@suse.de, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
In-Reply-To: <20080606092546.GA2596@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0806061030210.2354-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008, Pavel Machek wrote:

> Hi!
> 
> In 2.6.26-rc5, 
> 
> -config USB_PERSIST
> -       bool "USB device persistence during system suspend (DANGEROUS)"
> 
> is now on. Given that it was previously marked "DANGEROUS", that seems
> quite a change to me.

It is.  Basically I did it because Linus asked for it -- or at least,
for something like it.  He felt that the danger of not having
USB_PERSIST when you need it is worse than the danger of having it when
you don't want it.

> Besides, it seems to have broken usblp hibernation support, and maybe
> other devices that does not have reset_resume() present. (Big thanks
> for Oliver for doing investigation).

URL?  It's hard to see how lack of reset-resume support would mess 
anything up worse than it would be without USB_PERSIST.

> [Or is it that now USB_PERSIST is conditional on /sys fs setting, so
> while setting it on individual device is dangerous, it is still N by
> default? Changelog does not tell me...?]

USB_PERSIST is (and has always been) conditional on the power/persist
sysfs attribute setting.  The difference is that now the setting starts
out as On whereas before it started out as Off, and there no longer is
a Kconfig option to remove USB_PERSIST entirely.

Alan Stern


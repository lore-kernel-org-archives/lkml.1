Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab0CBXs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:48:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757532Ab0CBXrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:47:46 -0500
Date: Tue, 2 Mar 2010 15:46:14 -0800
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@novell.com>,
       Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 58/62] msi-laptop: Support some MSI 3G netbook that is
 need load SCM
Message-ID: <20100302234614.GA1680@suse.de>
References: <20100302230933.GA32287@kroah.com>
 <1267572541-410-58-git-send-email-gregkh@suse.de>
 <20100302233929.GB13739@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302233929.GB13739@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 11:39:29PM +0000, Matthew Garrett wrote:
> On Tue, Mar 02, 2010 at 03:28:57PM -0800, Greg Kroah-Hartman wrote:
> > From: Lee, Chun-Yi <jlee@novell.com>
> > 
> > Some MSI 3G netbook only have one fn key to control Wlan/Bluetooth/3G,
> > those netbook will load the SCM (windows app) to disable the original
> > Wlan/Bluetooth control by BIOS when user press fn key, then control
> > Wlan/Bluetooth/3G by SCM (software control by OS). Without SCM, user
> > cann't on/off 3G module on those 3G netbook.
> > On Linux, msi-laptop driver will do the same thing to disable the
> > original BIOS control, then might need use HAL or other userland
> > application to do the software control that simulate with SCM.
> > e.g. MSI N034 netbook
> 
> How does the function key event get reported to userland? This should 
> generate KEY_RFKILL and then just go through rfkill-input.

I'm pretty sure that Joey is using rfkill here, but I didn't realize
that it also supported an input device.

This code is just detecting the keypress, and acting on it, I think,
right Joey?  Isn't that the way this is supposed to work?  Or is it
supposed to use rfkill-input, which then userspace turns around and
calls the other rfkill interface to then disable the wireless?  If so, I
think a number of laptop drivers need to be changed to do this.

thanks,

greg k-h

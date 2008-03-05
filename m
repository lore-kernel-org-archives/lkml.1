Return-Path: <linux-kernel-owner+w=401wt.eu-S934111AbYCEADq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111AbYCEADq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYCEADc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:03:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36593 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYCEADc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:03:32 -0500
Date: Tue, 4 Mar 2008 16:03:26 -0800
From: Greg KH <greg@kroah.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 possible regression usbfs options ignored?
Message-ID: <20080305000326.GA4230@kroah.com>
References: <20080303215456.GA7747@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303215456.GA7747@ics.muni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 10:54:56PM +0100, Lukas Hejtmanek wrote:
> Hello,
> 
> I'm using 2.6.25-rc3. It seems that options for usbfs (devgid and devmode) are
> ignored.
> 
> # mount | grep usbfs
> none on /proc/bus/usb type usbfs (rw,devgid=46,devmode=0664)
> 
> /proc/bus/usb# ls -l
> total 0
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 001
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 002
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 003
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 004
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 005
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 006
> dr-xr-xr-x 2 root root 0 2008-03-03 10:41 007
> -r--r--r-- 1 root root 0 2008-03-03 22:30 devices
> 
> or am I just someting missing?

Wait, look in the directory for the devices, that is what you are
setting the option for:
	$ ls -l /proc/bus/usb/001/
	total 0
	-rw-rw-r-- 1 root usb 43 Mar  4 13:29 001
	-rw-rw-r-- 1 root usb 59 Mar  4 13:29 004
	-rw-rw-r-- 1 root usb 52 Mar  4 13:29 007
	$ mount | grep usb
	usbfs on /proc/bus/usb type usbfs (rw,noexec,nosuid,devmode=0664,devgid=85)

So I think everything is just fine, right?

thanks,

greg k-h

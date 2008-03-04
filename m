Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYCDFyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYCDFyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYCDFxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:53:50 -0500
Received: from mx1.suse.de ([195.135.220.2]:34191 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYCDFxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:53:49 -0500
Date: Mon, 3 Mar 2008 21:54:48 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Kristian H?gsberg <krh@bitplanet.net>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: reread config ROM when device reset the bus
Message-ID: <20080304055448.GB15566@suse.de>
References: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de> <tkrat.da30e6f15a74e036@s5r6.in-berlin.de> <59ad55d30803030817l6fce6716x2a97cc809b15b234@mail.gmail.com> <47CC2C95.1050205@s5r6.in-berlin.de> <59ad55d30803030928t47ab84ebs1f37434d6558b72e@mail.gmail.com> <47CC3C48.1020306@s5r6.in-berlin.de> <47CC44DB.1060203@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CC44DB.1060203@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 07:35:07PM +0100, Stefan Richter wrote:
> I wrote:
>>> On Mon, Mar 3, 2008 at 11:51 AM, Stefan Richter
>>> <stefanr@s5r6.in-berlin.de> wrote:
> [...rewriting data of a device with children devices whose driver probe 
> accesses these data...]
>>>>  Maybe I should rather use fw-device.c::idr_rwsem instead of device.sem,
>>>>  to have better control over who takes the mutex when.  Could also be a
>>>>  new dedicated mutex but we don't want to end up with too many of  
>>>> them...
> [...]
>> Ah, wait, there is a 3rd reader: sbp2_probe's sbp2_scan_unit_dir.  So, 
>> using dev->sem is actually the nicest way for now.
>
> Or not.  The necessary protection for this and other driver->probe()s would 
> be the device->parent.sem, not the device->sem itself.  There seem to be 
> several ways how a driver probe may be entered (adding a device when the 
> driver is already there; attaching a driver when the device is already 
> there...) and I am not sure whether all these paths take the 
> device->parent.sem around the probe.  It doesn't seem to be always the 
> case.
>
> Greg, can you comment on this?

Hm, comment on what?  Ah, semaphore fun in the device.  If at all
possible, use your own, not the driver core as the locking there is a
bit "odd" as you have seen.  I think Alan Stern has some patches pending
to mess with it all to try to make it sane during the suspend/resume
path.

thanks,

greg k-h

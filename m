Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbYCCSf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbYCCSf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYCCSfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:35:21 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49423 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbYCCSfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:35:20 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47CC44DB.1060203@s5r6.in-berlin.de>
Date: Mon, 03 Mar 2008 19:35:07 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>,
       =?ISO-8859-1?Q?Kristian_H=F8gs?= =?ISO-8859-1?Q?berg?= 
	<krh@bitplanet.net>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: reread config ROM when device reset the bus
References: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de>	 <tkrat.da30e6f15a74e036@s5r6.in-berlin.de>	 <59ad55d30803030817l6fce6716x2a97cc809b15b234@mail.gmail.com>	 <47CC2C95.1050205@s5r6.in-berlin.de> <59ad55d30803030928t47ab84ebs1f37434d6558b72e@mail.gmail.com> <47CC3C48.1020306@s5r6.in-berlin.de>
In-Reply-To: <47CC3C48.1020306@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
>> On Mon, Mar 3, 2008 at 11:51 AM, Stefan Richter
>> <stefanr@s5r6.in-berlin.de> wrote:
[...rewriting data of a device with children devices whose driver probe 
accesses these data...]
>>>  Maybe I should rather use fw-device.c::idr_rwsem instead of device.sem,
>>>  to have better control over who takes the mutex when.  Could also be a
>>>  new dedicated mutex but we don't want to end up with too many of 
>>>  them...
[...]
> Ah, wait, there is a 3rd reader: sbp2_probe's sbp2_scan_unit_dir.  So, 
> using dev->sem is actually the nicest way for now.

Or not.  The necessary protection for this and other driver->probe()s 
would be the device->parent.sem, not the device->sem itself.  There seem 
to be several ways how a driver probe may be entered (adding a device 
when the driver is already there; attaching a driver when the device is 
already there...) and I am not sure whether all these paths take the 
device->parent.sem around the probe.  It doesn't seem to be always the case.

Greg, can you comment on this?
-- 
Stefan Richter
-=====-==--- --== ---==
http://arcgraph.de/sr/

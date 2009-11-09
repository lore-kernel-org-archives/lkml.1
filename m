Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZKISI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZKISI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZKISIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:08:25 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:33728 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZKISIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:08:25 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4AF85ABB.7060406@cam.ac.uk>
Date: Mon, 09 Nov 2009 18:08:59 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091029)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-omap@vger.kernel.org
CC: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 1/2] staging: iio: tsl2563 ambient light sensor driver
References: <1257772468-4004-1-git-send-email-amit.kucheria@verdurent.com> <4AF81FE5.5080102@cam.ac.uk> <20091109142430.GZ1773@smtp.gmail.com>
In-Reply-To: <20091109142430.GZ1773@smtp.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Kucheria wrote:
> On 09 Nov 09, Jonathan Cameron wrote:
>> Hi Amit,
>>
>> Normally I'd welcome this in IIO, except that all ambient light sensors are in the
>> process of moving to the new ALS subsystem.  There are still some issues to resolve
>> in that subsystem (mainly to do with naming conventions) but hopefully we will
>> get them sorted out shortly.
> 
> Groan! :)
You have my sympathies on this! Typical that the first other developer to put
forward a patch for IIO picks the one type of device we are moving out.
If you do have any comments on IIO as a result of using it please send them
on.
> Who will be the subsystem maintainer and is there already a public git
> tree?
No git tree as far as I know.  Maintainer is Zhang Rui (Cc'd)
Zhang, what are your plans wrt to that?  I guess I can put one up with the current
patches if it is helpful?  We really need to sort out the naming issue as the one
thing that people have come out against. 

After that I'm guessing ping Andrew Morton to see if he is willing to handle the push
to Linus? Or does Zhang want to try doing one directly?

>> I'll take a close look at this sometime over the next few days though.  On a quick
>> glance at the data sheet, it looks very similar to the tsl2561.  Perhaps we can merge
>> the drivers? Yours is certainly more complete than the tsl2561 version in IIO so it
>> would make sense to lift the functional elements in to the code I have for an ALS
>> driver. I hadn't posted that previously as I hadn't quite worked out how to handle
>> the various gain related settings. What you have done seems to make sense (from a very
>> quick look.)
> 
> I've got no problem merging the tsl2563 with 2561. I don't have any 2561
> hardware to check a merged driver though.

On a reasonably thorough review of data sheets I think the only difference is the
input voltage range and a few timing parameters.  These two chips even use the same
addresses.  I'll actually test your driver against the tsl2561 sometime later in the
week to be sure.  So the merge looks like adding a few more lines to the i2c_device_id
table.  As a quick comment you would ideally have the tsl2563 and tsl2562 in there
already.
> 
> 
> Do you think the ALS framework will be finalised before the 2.6.33 merge
> window (in a few weeks)? If not, I wonder if Greg would take this driver to
> staging to begin with and I'll modify it to use the ALS subsystem when it
> settles down.
I'm certainly happy with that as an option if Greg is willing. In fact,
adding this with tsl2560-> tsl2563 support and removing the current tsl2561 driver would
be great (post any reviews over the next couple of days).

Thanks,

Jonathan

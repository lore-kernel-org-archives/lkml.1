Return-Path: <linux-kernel-owner+w=401wt.eu-S933052AbXIFVAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbXIFVAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 17:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932304AbXIFU74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:59:56 -0400
Received: from main.gmane.org ([80.91.229.2]:46589 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279AbXIFU74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:59:56 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Re: udev: Inconsistency between %b and %p?
Date: Thu, 06 Sep 2007 23:05:24 +0200
Message-ID: <fbppo0$rli$1@sea.gmane.org>
References: <fbp6a3$k6r$1@sea.gmane.org> <jeodgfu6pz.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd4c237.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.6) Gecko/20070809 SeaMonkey/1.1.4
In-Reply-To: <jeodgfu6pz.fsf@sykes.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
>> As I would prefer to use the USB device information (idVendor, idProduct)
>> to detect the device, I also tried this one:
>>
>> ATTRS{idVendor}=="0dda", ATTRS{idProduct}=="2005", SUBSYSTEM=="scsi",
>> ACTION=="add", PROGRAM+="/usr/bin/test.sh %b %p"
>>
>> Now this version returns the USB device ID ($NUM-$NUM) to the test script,
>> but the device path (%p) is still OK and still goes down up to the SCSI
>> device ID.
>>
>> Why does %b not return the SCSI device ID in the second rule?
> 
> Because ATTRS has matched the USB device, not the SCSI device.

Yes, that's right, but "SUBSYSTEM" matched the SCSI device...

If I use udevinfo, then this tool tells me:

| A rule to match, can be composed by the attributes of the device
| and the attributes from one single parent device.

So I thought, that I've matched the SCSI device now. To prove this, I 
just replaced "SUBSYSTEM=="scsi"" with "SUBSYSTEM=="usb"" and removed 
the "S" in the "ATTRS" of the above rule, and now, I get the USB-device 
in %b (as expected) and the path in %p only goes down up to the USB 
device ID.

So, if all rules match for the same device, then %b and %p are both 
pointing to this, right, device.

If I try to match, using one of the parent devices (using the "S" 
"extension" to the property names) and the device, to match to, itself, 
then the two are inconsistent. Then, %b holds the device name of the 
parent and %p holds the patch of the device, I want to match.

For me, this looks like a bug, or am I wrong?

Yours

Manuel


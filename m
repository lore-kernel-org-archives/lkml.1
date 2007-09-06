Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbXIFP2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbXIFP2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 11:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbXIFP2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 11:28:22 -0400
Received: from main.gmane.org ([80.91.229.2]:41192 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbXIFP2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 11:28:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: udev: Inconsistency between %b and %p?
Date: Thu, 06 Sep 2007 17:33:44 +0200
Message-ID: <fbp6a3$k6r$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd4c237.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.6) Gecko/20070809 SeaMonkey/1.1.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to write a UDEV rule, which has to hand over the SCSI device 
ID in the format $HOST:$CHANNEL:$ID:$LUN to a shellscript.

My first try was:

ATTR{vendor}=="XXXX", ATTR{model}=="XXXX", SUBSYSTEM=="scsi", 
ACTION=="add", PROGRAM+="/usr/bin/test.sh %b %p"

This returns the SCSI device ID and the device path up to the SCSI 
device to my test script.

As I would prefer to use the USB device information (idVendor, 
idProduct) to detect the device, I also tried this one:

ATTRS{idVendor}=="0dda", ATTRS{idProduct}=="2005", SUBSYSTEM=="scsi", 
ACTION=="add", PROGRAM+="/usr/bin/test.sh %b %p"

Now this version returns the USB device ID ($NUM-$NUM) to the test 
script, but the device path (%p) is still OK and still goes down up to 
the SCSI device ID.

Why does %b not return the SCSI device ID in the second rule?

Thanks in advance

Yours

Manuel


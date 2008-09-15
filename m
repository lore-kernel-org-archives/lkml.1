Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYIOItS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYIOItS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 04:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYIOItF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 04:49:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:41173 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYIOItC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 04:49:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding:sender;
        b=s8c4WuNtTD1pSZvVcwdFvNTZlgpJgW/pCnM65ExyiiYDlZX2JSYZaPX0kbzj3bVmUr
         rb/y3lKfDFb1KDhq8ldGwFsgKWuG1ahCwNveqehN78ULAXS+isv2jhQbIIFLrWDumCn5
         +iyPinUjWKf9NRfrE6rQZbZY/IxnJsGsiyk9I=
Message-ID: <48CE217A.1080409@tuffmail.co.uk>
Date: Mon, 15 Sep 2008 09:48:58 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Turning off camera also kills card reader on EeePC 900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:

> When running Ubuntu from an SD card issuing
> echo 0 > /sys/devices/platform/eeepc/camera
> as root will cause the camera to be turned off AND the SD card to
> immediately disappear (which is rather fatal when you are using it). It's
> hard to know if this is intended behaviour by the BIOS (given that they
> are both USB devices) or a mistake in the platform driver...

It's a bug either way (a regression from the 701 hardware).  I think you
should be able to isolate it.

Firstly, I understand these kill-switches are supposed to be persistent
over reboots.  You should check that the SD card stays disabled when you
reboot.

Next, these settings are also exposed in the BIOS configuration screen,
right?  If it's the same as my 701 then the BIOS will have a separate
option for disabling the cardreader.  So you could see if the platform
driver "camera" switch is simply disabling and enabling the two switches
together.

Or if there's only a BIOS option for the camera, and not the SD card,
then you should test whether it disables the SD card.

Regards
Alan

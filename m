Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbYI2ULS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbYI2ULS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 16:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYI2ULJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 16:11:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:2067 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYI2ULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 16:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=VExhiliW8P8oZS682DF3gTH9ByVBStxdeVhzHvl1nITFkslQfUJFJqx3H3jAVzpugp
         Ow9pN4i6FNVOGjF2dlVN5n0a5QlfISgZd74Ukwb0DE/Sn5D/Szw6+PHIHItU1wHbZ1NA
         AToU2iIy6/v4Kd6rkoLCIqOHmvih1bUrC9EFk=
Subject: Put unused PCI devices in D3
From: "Jeffrey W. Baker" <jwbaker@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 29 Sep 2008 13:11:03 -0700
Message-Id: <1222719064.19236.129.camel@squeak.gghcwest.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My laptop computer has half a dozen unused PCI devices that could be put
in the D3 power state, but they loiter in D0.  The audio codec, the
ethernet adapter, the unused PCI Express port, all the USB controllers,
the IEEE1394 controller, the SD/MMC card controller, and the cardbus
bridge all support D3(hot) power state.

Currently it looks to me from browsing the code that D3 is only used in
Linux when the whole machine is headed for S3, and the drivers are asked
to suspend.  I think the drivers should be able to enter D3 in other
circumstances:

* During pci_unregister_driver ... i.e. on module unload
* When a network interface is downed
* If the device is a bridge or hub with no downstream device
* Whenever userspace requests D3 via sysfs

So, what fundamental problem prevents me from, for example, calling
pci_set_power_state() from ohci1394's __exit?

-jwb


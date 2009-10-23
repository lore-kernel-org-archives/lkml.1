Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZJWQW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZJWQW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 12:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZJWQWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 12:22:25 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:15724 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZJWQWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 12:22:25 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Fix null pointer error after vmbus loading
Thread-Topic: [PATCH] Fix null pointer error after vmbus loading
Thread-Index: AcpShBhhaH+7AN1gRFKVV/A3W6FqAwAVoFqAABKi7GAAIBHtAAAVkcVw
Date: Fri, 23 Oct 2009 16:22:26 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF72180B430B@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF72180B39CA@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20091021224337.GA8550@suse.de>
 <1FB5E1D5CA062146B38059374562DF72180B3D51@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20091022225530.GA11244@suse.de>
In-Reply-To: <20091022225530.GA11244@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> But this is not how you check to see if your device is registered at
> all, you can not rely on the driver core to have the name set or not to
> reflect the status of the device.  Devices have many stages in their
> lifecycle, and the name reliably shows none of them.
> 
> Actually, why do you need to know this?  Shouldn't you always know the
> state of your device, how can you get passed an unregistered device?

I have traced down the callers to the function, vmbus_child_device_register(),
and verified that the struct device was kzalloc-ed by the current thread,
and not visible to other threads before we register the device. So the 
dev name is always NULL here, we can skip the NULL & strlen checking. I 
will send you the new patch soon.

Thanks,

- Haiyang


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbXDZUv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbXDZUv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbXDZUv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:51:59 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:56940
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbXDZUv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:51:58 -0400
Subject: compat_ioctl question
From: Paul Fulghum <paulkf@microgate.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 15:51:57 -0500
Message-Id: <1177620717.5060.11.camel@amdx2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I need to add ioctl translations for my driver to
allow 32 bit access on 64 bit systems.

After digging through the kernel code there seems to be
3 methods of doing this:

1. define compat_ioctl() file operation for device and
    implement translation code in individual driver
2. add COMPATIBLE_IOCTL entry to include/linux/compat_ioctl.h
    to mark an ioctl code as the same in any environment
3. add HANDLE_IOCTL entry to fs/compat_ioctl.c with translation code
    implemented in the same file

There is no way to implement #1 for a tty driver without
modifying the kernel tty code to allow registration of a
compat_ioctl() handler.

#3 would put a lot of driver specific stuff in a common
kernel file. This method also seems to break if there
is an ioctl code collision.

All of these methods involve changes to code outside of my driver.

--

Before I spend a lot of time on this I need to know what the
officially sanctioned method is. I haven't found any definitive
documentation and a review of mailing list archives does not
suggest a prevailing opinion.

Does anyone have pointers on which way would be most likely
to be accepted as a patch?

Thanks,
Paul


-- 
Paul Fulghum
Microgate Systems, Ltd


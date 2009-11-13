Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbZKMT3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbZKMT3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbZKMT3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:29:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:53045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246AbZKMT3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:29:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Philip Downer <phil@csldevices.co.uk>
Subject: Re: firmware loading interface
Date: Fri, 13 Nov 2009 20:29:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <4AFD971C.3090204@csldevices.co.uk> <4AFD9BAF.1010200@csldevices.co.uk>
In-Reply-To: <4AFD9BAF.1010200@csldevices.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911132029.01432.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18ZJVl0ODC6eSLViRsGZ2jh1OBhEcFCdxiqigw
 dw0NDQrz9bjRdBuE+IP/O8agL7A6CZXuNb9+RN+Fv93QPbc7mA
 WA8Y+KdkOXgKb2bU2+mSg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009, Philip Downer wrote:
> However our device will have flash to store the firmware in and, whilst
> it looks as though it would be possible for us to use request_firmware
> to provide occasional firmware upgrades from userspace, I can't find any
> reference as to whether this is an accepted method for doing so. Could
> someone please confirm for me whether or not it's a good idea to use
> request_firmware for this, or perhaps point me at another standard
> method for doing firmware updates from userspace?

The idea of request_firmware is that it helps you load the firmware
into the device at initialization time so you can use it directly,
without making the firmware blob a part of the kernel driver.

If I understand you correctly, you never need a firmware in user space
in order to use the device, but only for flashing a new version into
the nonvolatile memory.

The easiest way to do that would be an ioctl operation, if you are
implementing a character or block device interface anyway. Just load
the firmware into the RAM of a user application and call an ioctl
with the pointer to the firmware as an argument, but don't use
a data structure with a pointer in it, which would mess up 32 bit
compatibility operation.

If you don't implement a character or block device, the chances are
that you need something else besides an ioctl, depending on how
an application would communicate with your hardware.

	Arnd <><

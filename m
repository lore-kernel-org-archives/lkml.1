Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbZC2QCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbZC2QCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZC2QCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:02:46 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:43973 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbZC2QCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:02:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=ISO-8859-15; format=flowed
X-IronPort-AV: E=Sophos;i="4.38,442,1233529200";   d="scan'208";a="3173361"
Message-id: <49CF9BA1.5030400@archlinux.org>
Date: Sun, 29 Mar 2009 18:02:41 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
To: linux-kernel@vger.kernel.org
Cc: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: fastboot/async and initramfs: How am I supposed to know when devices
 are finished initializing?
X-Enigmail-Version: 0.95.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, I have this problem in 2.6.29 with the "fastboot" option and in 
today's linux-2.6.git.

In initramfs, we run the following commands:
     /sbin/udevd --daemon
     /sbin/udevadm trigger
     /sbin/udevadm settle
Among other things, this loads the ata_piix on my machine. On older 
kernels I could assume that after these commands, /dev/sda* existed and 
I could immediately access them (in my case, I run cryptsetup on 
/dev/sda6). But now, the devices don't exist here, but are only created 
a second or so later. As a result, the initramfs script has already 
bailed out as it couldn't find /dev/sda6 and assumed that the hard drive 
didn't exist.

So my question is, if udevadm settle doesn't wait for the devices 
anymore, how am I supposed to know when the devices have been created? 
If there is no way to know, I would consider this a regression, as it is 
no longer possible to cleanly write initramfs scripts.

Thanks for you replies
Thomas Bächler
Arch Linux Developer

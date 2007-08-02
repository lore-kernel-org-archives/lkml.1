Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbXHBRph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbXHBRph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758395AbXHBRpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:45:30 -0400
Received: from max.aladin.ro ([80.96.155.2]:39753 "EHLO aladin.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbXHBRp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:45:28 -0400
Message-ID: <46B21833.600@aladin.ro>
Date: Thu, 02 Aug 2007 20:45:23 +0300
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Dynamic major/minor numbers (or dropping them completely)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*This message was transferred with a trial version of CommuniGate(r) Pro*
Currently, the kernel has the following properties:
1) initramfs can be used to boot the system. We don't need any 
predefined /dev entries.
2) udev can be started from the initramfs to create the required entries 
in /dev. udev doesn't care about major/minor numbers.
3) Most distros already use udev and maybe initramfs. If there are 
exceptions, they can be easily converted.

For the first part, I'm asking: is there any reason why new char/block 
drivers shouldn't use dynamic major/minor numbers? Is there any reason 
against converting the whole kernel to dynamic major/minor numbers?

Okay, maybe the previous questions looked useless from a pragmatic POV. 
But why shouldn't the whole major/minor numbering system be dropped 
completely? sysfs already maintains a hierachy of device drivers and 
kernel subsystems, one which is better than the major/minor system. The 
current system could be replaced by a single-numbered, 
dynamically-allocated scheme.

Device files could be stored on a tmpfs filesystem, so that we don't 
make any changes to current filesystems. Apps won't need to be modified, 
since they access /dev entries by name, provided udev maintains the 
current naming scheme.

Any thoughts on this?

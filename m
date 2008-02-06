Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbYBFOye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbYBFOye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 09:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYBFOyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 09:54:15 -0500
Received: from mail.syneticon.net ([213.239.212.131]:49683 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYBFOyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 09:54:13 -0500
Message-ID: <47A9CA0E.3030507@wpkg.org>
Date: Wed, 06 Feb 2008 15:54:06 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Mika Lawando <rzryyvzy@trashmail.net>
Subject: What is the limit size of tmpfs /dev/shm ? 
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello Kernel Users,
> 
> is there a size limit for tmpfs for the /dev/shm filesystem?
> Normally its default size is set to 2 GB. Is it possible to create a 2 
> TB (Terrabyte) filesystem with tmpfs?
> Or is there a maximum size defined in the linux kernel?

Depends on your arch.

If it's 32 bit, it's limited to 16TB:

# mount -o size=16383G -t tmpfs tmpfs /mnt/2
# df -h
(...)
tmpfs                  16T     0   16T   0% /mnt/2

# umount /mnt/2

# mount -o size=16385G -t tmpfs tmpfs /mnt/2
# df -h
(...)
tmpfs                 1.0G     0  1.0G   0% /mnt/2


So 16384G would mean the same as 0.


If you're 64 bit, you need to have really loads of storage and/or RAM to 
accumulate 16EB:

# mount -t tmpfs -o size=171798691839G tmpfs /mnt/2
# df -h
(...)
tmpfs                  16E     0   16E   0% /mnt/2


-- 
Tomasz Chmielewski
http://lists.wpkg.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762554AbZFNQdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554AbZFNQdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 12:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZFNQde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 12:33:34 -0400
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:2000 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbZFNQdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 12:33:33 -0400
Message-ID: <4A352572.50602@alice.it>
Date: Sun, 14 Jun 2009 18:29:38 +0200
From: Marco <firefox82@alice.it>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Marco <marco.stornelli@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 04/14] Pramfs: Mounting as root filesystem
References: <4A33A7D7.3040008@gmail.com> <200906140104.43463.arnd@arndb.de>	 <4A34B2FD.20701@gmail.com> <1244970445.3468.2732.camel@macbook.infradead.org> <4A351FB0.3060008@gmail.com>
In-Reply-To: <4A351FB0.3060008@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2009 16:33:34.0086 (UTC) FILETIME=[DC29E260:01C9ED0D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Sun, 2009-06-14 at 10:21 +0200, Marco wrote:
>> Mmm...MEM_MAJOR and RAMDISK_MAJOR have the same value and pramfs works
>> in memory. We could simply use /dev/null (there was an error in the
>> submitted kconfig description, my intention was to use /dev/mem). In
>> that case I can use UNNAMED_MAJOR. PRAMFS root option is not enabled
>> if it's already enabled the NFS one. What do you think?
>
> Why use a major number at all? See how we handle mtd and ubi devices in
> prepare_namespace() -- can't you do something similar?
>
 
Do you suggest me something similar? Why not. I though that mtd and ubi 
were only special cases.

if (saved_root_name[0]) {
		root_device_name = saved_root_name;
		if (!strncmp(root_device_name, "mtd", 3) ||
		    !strncmp(root_device_name, "ubi", 3) ||
  -------->         !strncmp(root_device_name, "pram", 4)) {
			mount_block_root(root_device_name, root_mountflags);
			goto out;
		}
		ROOT_DEV = name_to_dev_t(root_device_name);
		if (strncmp(root_device_name, "/dev/", 5) == 0)
			root_device_name += 5;
	}

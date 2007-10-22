Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbXJVL2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbXJVL2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbXJVL16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:27:58 -0400
Received: from relay4.usu.ru ([194.226.235.39]:42814 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbXJVL15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:27:57 -0400
Message-ID: <471C8937.9010007@ums.usu.ru>
Date: Mon, 22 Oct 2007 17:27:51 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); ru-RU; rv:1.8.0.13pre) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.10~pre070720-0etch3+lenny1) Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: Henrik Carlqvist <hc1@poolhem.se>, linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
References: <200710201257.55616.nick@ukfsn.org> <20071020144238.4f258c8c.hc1@poolhem.se> <20071022101107.GA20690@infradead.org> <471C7C33.4090003@ums.usu.ru> <20071022105727.GA22181@infradead.org>
In-Reply-To: <20071022105727.GA22181@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Oct 22, 2007 at 04:32:19PM +0600, Alexander E. Patrakov wrote:
>   
>>> That's wrong.   You can load firmware from the initramfs even if the
>>> driver is built in.  There is no valid reason why a driver shouldn't
>>> be allowed to be built in.
>>>       
>> Could you please explain how this is supposed to work?
>>
>> As far as I understand, the kernel initializes all built-in drivers, and 
>> only then starts /init in initramfs (which is then supposed to start 
>> udevd and load firmware) - but that's too late.
>>     
>
> populate_rootfs is a rootfs_initcall which happens before all the driver
> initcalls.
>   

Correct, but irrelevant. The firmware indeed gets unpacked to rootfs 
before all driver initcalls, but stays as a dead weight during them, 
because udev (started by /init, which happens in init_post() called by 
kernel_init() after all initcalls) is needed to load this firmware.

Yes, there is a call to usermodehelper_init() before the initcalls in 
do_basic_setup(), this does mean that firmware can be loaded by means of 
the old and obsolete /sbin/hotplug mechanism, but who has /sbin/hotplug now?

-- 
Alexander E. Patrakov

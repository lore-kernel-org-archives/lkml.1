Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0CHXzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:55:31 -0500
Received: from xenotime.net ([72.52.64.118]:60671 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753357Ab0CHXz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:55:28 -0500
Message-ID: <4B958E6D.70006@xenotime.net>
Date: Mon, 08 Mar 2010 15:55:25 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] inquiry_cache_read: stack size
References: <20100308223759.GA27590@nb-core2.darkstar.lan>
In-Reply-To: <20100308223759.GA27590@nb-core2.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/10 14:38, Luca Tettamanti wrote:
> Hi Marcel,
> I'm compiling current -git kernel and noticed this warning:
> 
> net/bluetooth/hci_sysfs.c: In function 'inquiry_cache_read':
> net/bluetooth/hci_sysfs.c:441: warning: the frame size of 4208 bytes is larger than 2048 bytes
> 
> which is caused by:
> 
> commit ca325f698996c1a0770a67f41e7dc97a007d8bc2
> Author: Marcel Holtmann <marcel@holtmann.org>
> Date:   Mon Feb 8 16:22:31 2010 +0100
> 
>     Bluetooth: Convert inquiry cache to use debugfs instead of sysfs
> 
>     The output of the inquiry cache is only useful for debugging
>     purposes and so move it into debugfs.
> 
> This buffer on the stack:
> 
>     char buf[4096];
> 
> is likelly to cause troubles, since the kernel space stack is limited to
> 8K or even 4K (4KSTACKS).

Patch was on netdev mailing list on TUE Mar. 2, 2010.
Please see http://www.spinics.net/lists/netdev/msg122906.html

-- 
~Randy

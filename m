Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbZDJA5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbZDJA5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 20:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZDJA5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 20:57:36 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:48372 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZDJA5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 20:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=dtXQuZ03xste6fxEuTEjVi2X/i3W43Q4j++h+hhNG+dbJQOHBf/olml9t8UsKkx4vl
         Ti1b2WRs/PVQWO3xSnYsUFew9Zp/WoQPC4Qf5V89VjzCzn7UdyeqGBnEVB98cCeCZXy3
         Wv7p8qxDegbEYkR230DfutFhqa2vZCcZDeT4U=
Message-ID: <49DE9979.6060501@gmail.com>
Date: Thu, 09 Apr 2009 18:57:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Imre Gergely <gimre@narancs.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Finding lost memory + kernel messages explained
References: <49DDB609.8050405@narancs.net>
In-Reply-To: <49DDB609.8050405@narancs.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imre Gergely wrote:
> 
> Hi
> 
> I've just upgraded my laptop RAM from 1x2GB to 2x2GB. The BIOS says 
> 4096MB, memtest says 4031MB (I'm not sure why, but let's assume it's 
> right).
> 
> After Linux boots, Ubuntu 8.10 x86_64, with
> 
> Linux gimre-laptop 2.6.27-11-generic #1 SMP Wed Apr 1 20:53:41 UTC 2009 
> x86_64 GNU/Linux
> 
> I look at /proc/meminfo, and I don't have 4031MB:
> 
> gimre@gimre-laptop:~$ cat /proc/meminfo
> MemTotal:      3989844 kB
> MemFree:       3157756 kB

Your BIOS e820 memory map has this for usable memory:

0000000000000000 - 000000000009fc00 = 639KB
0000000000100000 - 00000000bffb0000 = 3070.7MB
0000000100000000 - 000000013c000000 = 960MB

total that your BIOS exposes to the OS: 4031 MB

That leaves 131MB, likely about 64MB of that is used for the IOMMU 
(which you need, since you presumably have devices that can't address 
memory over the 4GB address), and the rest is likely various kernel data 
structures (page tables, etc.)

> 
> That would be around 3896MB. My question is: where does the memory go? 
> Is it normal to 'lose' that much (~130MB) ?
> 
> Here's the dmesg output
> 
> http://pastebin.com/m4f7d089a
> 
> Also I would like to know more about those kernel messages, what do all 
> those numbers, and memory mappings and all that mean? Is there a 
> comprehensive manual / howto / wiki which explains all the messages in 
> more detail?
> 
> One thing I tried was appending iommu=off at boot, which gave me back 
> some 50MB, but there were still 80MB missing and the USB mouse didn't 
> work (among other things I'm sure).
> 
> Laptop is a HP Compaq 8510p.
> 
> Thanks.
> 


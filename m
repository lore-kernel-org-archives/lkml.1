Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbZAYMlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbZAYMlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 07:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZAYMlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 07:41:32 -0500
Received: from lucidpixels.com ([75.144.35.66]:51573 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbZAYMlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 07:41:31 -0500
Date: Sun, 25 Jan 2009 07:41:30 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
In-Reply-To: <alpine.DEB.1.10.0901250726530.10805@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0901250740360.11258@p34.internal.lan>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan> <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk> <alpine.DEB.1.10.0901250705300.6888@p34.internal.lan> <alpine.DEB.1.10.0901250715030.10379@p34.internal.lan>
 <alpine.DEB.1.10.0901250726530.10805@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 Jan 2009, Justin Piszcz wrote:

>
>
> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>
>> 
>> 
>> On Sun, 25 Jan 2009, Justin Piszcz wrote:
>> 
>>> 
>>> 
>>> On Sun, 25 Jan 2009, Alan Cox wrote:
>>> 
>>>> Easiest is to use labels. Old ide will keep hda,b,c,d constant
>>>> providing you have interfaces using the legacy IDE port mappings (0x1f0
>>>> and 0x170). Libata doesn't do that as pretty much every distribution had
>>>> already switched to volume labels, and the user space can do the job far
>>>> better than the kernel - especially as the newer devices with modern
>>>> interfaces don't have the old BIOS/DOS legacy ideas any more.
>>>> 
>>>> Mount by label also means you can flip back and forth between the
>>>> different drivers and kernel revisions.
>>>> 
>>>> Alan
>>>> 
>> It comes with one :)
>> # xfs_admin -u  /dev/sdd2
>> UUID = 77ae4251-631f-4656-a365-c5723f5c5da8
>> 
>> Will try to use this to boot; however, I'd prefer the labels over the UUID, 
>> wish there was an easy way to set it.
>> 
>> Justin.
>> 
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>> 
>
> One final question, without udev, how does one determine the UUID of a 
> non-XFS
> partition, e.g., swap?
>
> $ ls -l
> total 0
> lrwxrwxrwx 1 root root  9 2009-01-25 01:54 
> 203fcd30-4e56-40e9-a8e5-93ddc8eb536a -> ../../md0
> lrwxrwxrwx 1 root root 10 2009-01-25 01:54 
> 2ef862e1-cf78-4065-a205-d1784716d633 -> ../../sdd1
> lrwxrwxrwx 1 root root 10 2009-01-25 01:54 
> 77ae4251-631f-4656-a365-c5723f5c5da8 -> ../../sdd2
>
> p254:~# find /proc/|grep -i uuid
> /proc/sys/kernel/random/uuid
> p254:~# find /sys/|grep -i uuid p254:~#
>
>

In lilo.conf:
root="UUID=77ae4251-631f-4656-a365-c5723f5c5da8"

image=/boot/2.6.28-4
         label=2.6.28-4
         read-only
         root="UUID=77ae4251-631f-4656-a365-c5723f5c5da8"

The /etc/fstab entry works, but not the LILO one.

Also I found a bug (OOPS) with a box I was testing the new subsystem 
(SATA vs. old IDE) with, will send a bug report shortly.

Justin.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYFJWsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYFJWsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYFJWsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:48:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44104 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYFJWsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:48:12 -0400
Message-ID: <484F04A7.1090503@zytor.com>
Date: Tue, 10 Jun 2008 15:48:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: devzero@web.de
CC: keith@karsites.net, linux-kernel@vger.kernel.org
Subject: Re: Problems with edd
References: <311993399@web.de>
In-Reply-To: <311993399@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
>> Hi all. I have a problem with trying to boot from a Fedora 9 
>> installation CD-R. It works on another machine, so the disk 
>> is OK. I guess if anyone knows the answer then it will be 
>> found here on the kernel developers list.
>>
>> When trying to boot from a CD-R installation disk, on my 
>> Advent 6415 laptop I get the following:
>>
>> Welcome to Fedora 9! [the installer splash screen]
>>
>>  I then click on either:
>>
>>  Install or upgrade an existing system
>>  [or]
>>  Install or upgrade an existing system (text mode)
>>
>>  [both give me the same following error]
>>
>> Loading vmlinuz........................................... 
>> ..............
>>
>>  Loading initrd.img........................................ 
>> .................
>>  ...............ready.
>>  Probing EDD (edd=off to disable)... ok
>>  vmlinuz: attempted DOS system call
>>  boot:

This message means something has invoked an interrupt in the range 0x20 
to 0x3f, which it should never have done, since that's in the operating 
system range.

Given the complaint about vesamenu further down the page, I'm assuming 
the VESA BIOS is invoking a DOS interrupt(!!!!)... although it's very 
hard to say for sure.

It might be possible to track down by augmenting syslinux to print the 
CS:IP of the supposed DOS system call; if this is the VESA BIOS, it 
would be in the range C000:xxxx.

This probably would be a useful hack anyway, so I'll just implement it.

	-hpa

Return-Path: <linux-kernel-owner+w=401wt.eu-S932603AbXGXU6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbXGXU6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932605AbXGXU5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:57:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422AbXGXU5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:57:41 -0400
Message-ID: <46A667BD.5080106@redhat.com>
Date: Tue, 24 Jul 2007 16:57:33 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ulrich Kunitz <kune@deine-taler.de>,
       linux-kernel@vger.kernel.org, honza@jikos.cz, jkosina@suse.cz
Subject: Re: Is PIE randomization breaking klibc binaries?
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com> <46A6624E.60003@redhat.com>
In-Reply-To: <46A6624E.60003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2007 04:34 PM, Chuck Ebbert wrote:
> On 07/20/2007 06:05 PM, H. Peter Anvin wrote:
>>> It looks like that the PIE randomization patch breaks klibc
>>> binaries on x86-64.
>>>
>> Interesting.
>>
>> klibc binaries are indeed statically linked, but composed of two
>> different ELF images: the application itself and the shared libary
>> (which is referenced from the application header as the "interpreter").
>>  Neither of these is an ET_DYN file; they are both ET_EXEC, so it
>> *should* be unaffected by the PIE randomization patch.  Obviously, that
>> seems to not be the case.
>>
>> My guess is that this patch mishandles interpreter images which are
>> ET_EXEC.  Jan, any insight?
> 
> Well, they don't run on Fedora 6 either (which has the same code, it's
> part of exec-shield):
> 
> $ strace ./cat
> execve("./cat", ["./cat"], [/* 55 vars */]) = -1 ENOENT (No such file or directory)
> ...
> $ file cat
> cat: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), statically linked (uses shared libs), stripped
> 
> Funny nobody noticed that before...
> 

After installing klibc.so and klibc-<ID>.so into /lib everything works:

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz  MemSiz   Flg Align
  PHDR           0x000034 0x08048034 0x08048034 0x0000a0 0x0000a0 R E 0x4
  INTERP         0x0000d4 0x080480d4 0x080480d4 0x00002a 0x00002a R   0x1
        [Requesting program interpreter: /lib/klibc-58kBUyV_qhVvkMnaxy8A7N8rLak.so]

Ulrich, did your initrd contain the correct .so? Did you try rebuilding klibc after
building the new kernel?

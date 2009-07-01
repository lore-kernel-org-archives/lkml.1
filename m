Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZGAMKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZGAMKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 08:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZGAMJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 08:09:55 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:53052 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbZGAMJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 08:09:54 -0400
Message-ID: <4A4B5213.9060003@monstr.eu>
Date: Wed, 01 Jul 2009 14:09:55 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [microblaze-uclinux] [PATCH 03/11] microblaze: fall back on generic
 header files for the ABI
References: <cover.1245345894.git.arnd@arndb.de> <7a92dd639b7887bc972118d16a5fda6093200b96.1245347640.git.arnd@arndb.de> <4A4B49D0.2090101@monstr.eu> <200907011342.26669.arnd@arndb.de>
In-Reply-To: <200907011342.26669.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnd Bergmann wrote:
> On Wednesday 01 July 2009, Michal Simek wrote:
>> Added to next branch for test.
>>
>> I had to do one change.
>> Microblaze needs __kernel_mode_t as short.
> 
> Can you explain why that is needed? Should I change the default in the generic file?

I did this change because of problem with inconsistency between kernel/glibc.

Current our glibc ipc_perm struct - mode is short - that's why I have setup kernel_mode_t to short too.

/* Data structure used to pass permission information to IPC operations.  */
struct ipc_perm
  {
    __key_t __key;			/* Key.  */
    __uid_t uid;			/* Owner's user ID.  */
    __gid_t gid;			/* Owner's group ID.  */
    __uid_t cuid;			/* Creator's user ID.  */
    __gid_t cgid;			/* Creator's group ID.  */
    unsigned short int mode;		/* Read/write permission.  */
    unsigned short int __seq;		/* Sequence number.  */
    unsigned short int __pad1;
    unsigned long int __unused1;
    unsigned long int __unused2;
  };

Does it make more sense to define it as int?

Michal

> 
>> + I removed __kernel_size_t and I'll recompile toolchain
>> for removing warning messages
> 
> Ah, good.
> 
> 	Arnd <><
> ___________________________
> microblaze-uclinux mailing list
> microblaze-uclinux@itee.uq.edu.au
> Project Home Page : http://www.itee.uq.edu.au/~jwilliams/mblaze-uclinux
> Mailing List Archive : http://www.itee.uq.edu.au/~listarch/microblaze-uclinux/
> 
> 

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab0CDEwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 23:52:22 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48342 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab0CDEwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 23:52:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=edNwjj+l4LMpHXAXjkr3EGAvBXj4eEinAwLNm4rsMuPPBBRKOihSsvp8wEit541njZ
         ZBG/xp9bF+B4kxlcmOEOvb8CMrCrkuo44MGnx7EQOy7Q8oqdQjBrkEiw6q2bwRnPOFDf
         9NBoUSLTR74+O7ogbadQyI8KSECcyXmKtWJKs=
MIME-Version: 1.0
Date: Wed, 3 Mar 2010 23:52:20 -0500
Message-ID: <f875e2fe1003032052p944f32ayfe9fe8cfbed056d4@mail.gmail.com>
Subject: Linux kernel - Libata bad block error handling to user mode program
From: foo saa <foosaa@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi everyone,

I am in the process of writing a disk erasure application in C. The
program does zerofill the drive (Good or Bad) before someone destroys
it. During the erasure process, I need to record the number of bad
sectors during the zerofill operation.

The method used to write to the hdd involves opening the appropriate
/dev block device using open() call with O_WRONLY flag, start issuing
write() calls to fill the sectors. A 512 byte buffer filled with
zero's is used. All calls are of 64bit enabled. (I am using
_LARGEFILE64_SOURCE define).

The problem is (mostly with the bad hdd's), when the write call
encounters a bad sector, it takes a bit longer than usual and writes
the sector without any errors. (dmesg shows a lot of error messages
embedded in the LIBATA error handling code!). The call never fails for
any reason.

I am using 2.6.27-7-generic  and gcc version 4.3.2  on ubuntu 8.10. I
have tried upto 2.6.30.10 and multiple distros with similar behavior.

Here is a summary of things I have attempted.

I know about the bad sector and it's location on the hdd, since it has
been verified by using Windows based hex editor utilities, DOS based
erasure applications, MHDD and many other HDD utilities.

I have tried using O_DIRECT with aligned buffers, but still could not
identify the bad sectors during the writing process.

I have tried using fadvise, posix_fadvise functions to get of the
caching, but still failed.

I have tried using SG_IO and SAT translation (direct ATA commands with
device addressing) and it fails too. Raw devices is out of question
now.

The libata is not letting / informing the user mode program (executing
under root) about the media / write errors / bad blocks and failures,
though it notifies the kernel and logs to syslog. It also tries to
reallocate, softreset, hardreset the block device which is evident
from the dmesg logs.

What has to be done for my program to identify / receive the bad block
/ sector information during the read / write process?

How can I receive the bad sector / physical and media write errors in
my program? This is my only requirement and question.

I am currently out of options unless anyone from here can show some
new direction!

My only option is to recompile the kernel with libata customization
and changes according to my requirement. (Can I instruct to libata to
skip the error handling process and pass certain errors to my
program?).

Is this a good approach and recommended one? If not what should be
done to achieve it? If yes, can somebody throw some light on it?

Please let me know if you have any queries in my above explanation.

Thank you for reading this rather long post!

Regards
sponnusa

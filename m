Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbYDXCPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbYDXCPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 22:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYDXCPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 22:15:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:6934 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYDXCPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 22:15:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=cdknk+YoLGJgeegljYzqkQZXWkiL7oGBvFx4lsxANHIoyFIRD6T6kxs79e4kS1kIVUG4uVZMAAx/XgcTDktyg8ka+1bVtbadK1I5OgMH9Ggd+70f6sx42u9YU6MEFx6t4TJhk/WLihUEKv7vz2HN+/ZLPiMoPzcP9hKI0erYVvU=
Message-ID: <480FED34.1090003@gmail.com>
Date: Wed, 23 Apr 2008 21:15:16 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: HD5500 with weak signal locks up (and stays locked up), but does
 not return error to applications
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok,

Note that the mailing list listed in the linux-kernel maintainers file is a 
subscriber only mailing list and outright rejects all posts to the list by 
non-subscribers.   Though that it is listed that way in the maintainers file

Ever so often my HD5500 stops working in mythtv (empty/no file).   Once it 
starts happening getatsc also seems to also fail, stracing getatsc and/or mythtv 
has getatsc hanging on the read (blocking read) and has mythbackend getting 
EAGAIN on the read (nonblocking read).

I did find this in messages on 2.6.23, and this does appear to happen around the
time of it starting to fail (it also happens on 2.6.24.4):

kernel: cx88[0]: mpeg risc op code error
kernel: cx88[0]: mpeg - dma channel status dump
kernel: cx88[0]:   cmds: initial risc: 0x37bcf000
kernel: cx88[0]:   cmds: cdt base    : 0x00180800
kernel: cx88[0]:   cmds: cdt size    : 0x0000000a
kernel: cx88[0]:   cmds: iq base     : 0x001807c0
kernel: cx88[0]:   cmds: iq size     : 0x00000010
kernel: cx88[0]:   cmds: risc pc     : 0x37bcf048
kernel: cx88[0]:   cmds: iq wr ptr   : 0x000001f2
kernel: cx88[0]:   cmds: iq rd ptr   : 0x000001f6
kernel: cx88[0]:   cmds: cdt current : 0x00000818
kernel: cx88[0]:   cmds: pci target  : 0x350115e0
kernel: cx88[0]:   cmds: line / byte : 0x01650000
kernel: cx88[0]:   risc0: 0x1c0002f0 [ write sol eol count=752 ]
kernel: cx88[0]:   risc1: 0x350115e0 [ arg #1 ]
kernel: cx88[0]:   risc2: 0x1c0002f0 [ write sol eol count=752 ]
kernel: cx88[0]:   risc3: 0x350118d0 [ arg #1 ]
kernel: cx88[0]:   iq 0: 0x1c0002f0 [ write sol eol count=752 ]
kernel: cx88[0]:   iq 1: 0x1aa78490 [ arg #1 ]
kernel: cx88[0]:   iq 2: 0x1c0002f0 [ write sol eol count=752 ]
kernel: cx88[0]:   iq 3: 0x350112f0 [ arg #1 ]
kernel: cx88[0]:   iq 4: 0x1c0002f0 [ write sol eol count=752 ]
kernel: cx88[0]:   iq 5: 0x350115e0 [ arg #1 ]
kernel: cx88[0]:   iq 6: 0x1c0002f0 [ write sol eol count=752 ]
kernel: cx88[0]:   iq 7: 0x350118d0 [ arg #1 ]
kernel: cx88[0]:   iq 8: 0x1c0002f0 [ write sol eol count=752 ]
kernel: cx88[0]:   iq 9: 0x35011bc0 [ arg #1 ]
kernel: cx88[0]:   iq a: 0x18000150 [ write sol count=336 ]
kernel: cx88[0]:   iq b: 0x35011eb0 [ arg #1 ]
kernel: cx88[0]:   iq c: 0x140001a0 [ write eol count=416 ]
kernel: cx88[0]:   iq d: 0x1aa78000 [ arg #1 ]
kernel: cx88[0]:   iq e: 0x1c0002f0 [ write sol eol count=752 ]
kernel: cx88[0]:   iq f: 0x1aa781a0 [ arg #1 ]
kernel: cx88[0]: fifo: 0x00186400 -> 0x187400
kernel: cx88[0]: ctrl: 0x001807c0 -> 0x180820
kernel: cx88[0]:   ptr1_reg: 0x00186790
kernel: cx88[0]:   ptr2_reg: 0x00180818
kernel: cx88[0]:   cnt1_reg: 0x00000014
kernel: cx88[0]:   cnt2_reg: 0x00000000

Once it starts happening it requires a module unload/reload or a reboot get 
things working again.

 From viewing the recording happening at the time of the error, I believe this 
is a lockup caused be a less than perfect signal, and that given enough events 
of less than a perfect signal it eventually causes something to stop working and 
lockup.

Is there any more graceful recovery possible than just not working?

Or is does something fail down at a lower level than is reporting the above error?

At a minimum it would probably be good to return errors to the applications 
accessing the devices when this sort of thing happens, right now the 
applications don't notice the failure at all (except for not getting any 
data-which could just be a weak signal), but once this fault happens it happens 
on every channel-even channels that don't ever have signal issues, and ioctls 
and opens still appear to succeed even though the underlying modules are messed 
up and are never going to return any data until something is done.

                         Roger



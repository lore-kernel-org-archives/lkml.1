Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYHUHDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYHUHDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 03:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYHUHDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 03:03:33 -0400
Received: from mailbackup.inode.at ([213.229.60.24]:36965 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYHUHDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 03:03:33 -0400
Date: Thu, 21 Aug 2008 09:02:25 +0200
From: Sascha Biberhofer <biberhofer@inode.at>
To: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops in authenc: 2.6.26.3
Message-ID: <20080821070225.GA31894@aeris>
References: <20080820203245.ea01ff39.kernel1@cyberdogtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820203245.ea01ff39.kernel1@cyberdogtech.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have the same problem on my system, starting with the release of
2.6.26. Shortly afterwards I've had the same problem with the 2.6.25
series starting with 2.6.25.12. I've looked up the changes between
2.6.25.11 and .12 and found commit
c2bd04d8040a91fe2ee2e9fee1a6562ca9792249 (it's commit
872ac8743cb400192a9fce4ba2d3ffd7bb309685 in the 2.6.26 series).
Reverting the commit seems to solve the problem here, I've been running
a 2.6.25.12 kernel without this commit for some weeks now.
In case it's important: I'm using an IPSec ESP transport with AES-256
and sha-256 auth. 

My oops:

Pid: 4, comm: events/0 Not tainted (2.6.25.12 #0)
EIP: 0060:[<c0202d7b>] EFLAGS: 00010296 CPU: 0
EIP is at crypto_authenc_givencrypt_done+0x1b/0x20
EAX: 3e03add6 EBX: c9f29b60 ECX: 3e03add6 EDX: 00000000
ESI: c9f39b60 EDI: c9f39b50 EBP: de8bb7b0 ESP: df833f74
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process events/0 (pid:4, ti=df832000 task=df829020 task:ti=df832000)

Stack: 00000000 c01f4a60 de8bb7cc df808100 c01f4a10 df808100 c01277eb df829020
       c0383528 0000007b 0000007b df909100 df808108 c0127ee0 00000000 c0127f39
       00000000 df829020 c012a680 df833fc0 df833fc0 fffffffc df808100 c0127ee0

Call trace: [<c01f4a60>] async_chainiv_do_postponed+0x50/0x80
            [<c01f4a10>] async_chainiv_do_postponed+0x0/0x80
            [<c01277eb>] run_workqueue+0x8b/0x100
            [<c0383528>] schedule+0x148/0x280
            [<c0127ee0>] worker_thread+0x0/0x90
            [<c0127f39>] worker_thread+0x59/0x90
            [<c012a680>] autoremove_wake_function+0x0/0x40
            [<c0127ee0>] worker_thread+0x0/0x90
            [<c012a302>] kthread+0x42/0x70
            [<c012a2c0>] kthread+0x0/0x70
            [<c0103867>] kernel_thread_helper+0x7/0x10

Code: ff 09 03 e9 3e ff ff ff 90 8d b4 26 00 00 00 85 d2 53 89 c3 75 0f 8b 40 0c 31 c9 8b 50 38 e8 0c fc ff ff 89 c2 8b 4b 0c
      89 c8 <ff> 51 51 08 5b c3 85 d2 53 89 c3 75 18 8b 40 0c 8b 48 10 8d 50 58


hth, 
  Sascha Biberhofer

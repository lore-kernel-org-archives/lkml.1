Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYFSAae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYFSAae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757653AbYFSAaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:30:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:19107 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbYFSAaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cb+wCGbNoYK9O2+1vQK5T/AssxyA52xp5FtwyUw9s9rnUbodOHO3rhuWCVKcYhdehR
         h/jTPdGYMho6IhmRBaQzgtnpjZE3OVdRqdZOWn4tFl2ykzpvexEfr5PNnZCdCUJcGU03
         IAa6gpnY+hMjBaE1/rR417NVi5gzK7AI3bqC0=
Message-ID: <a01a16b50806181730gec225fbgf2057a727089c997@mail.gmail.com>
Date: Thu, 19 Jun 2008 02:30:08 +0200
From: "=?UTF-8?Q?H=C3=A5kon_L=C3=B8vdal?=" <hlovdal@gmail.com>
To: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0806111636330.16829@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080526115628.GA31316@elte.hu>
	 <Pine.LNX.4.64.0805312332270.2760@wrl-59.cs.helsinki.fi>
	 <a01a16b50806031710u54b9297bkf1fad9c4f8fd581f@mail.gmail.com>
	 <Pine.LNX.4.64.0806041402211.16829@wrl-59.cs.helsinki.fi>
	 <a01a16b50806040700h1efce63cq2a27b087df0d25be@mail.gmail.com>
	 <Pine.LNX.4.64.0806041802360.2580@wrl-59.cs.helsinki.fi>
	 <a01a16b50806060232u1eff3867u24fecc539fda1d14@mail.gmail.com>
	 <Pine.LNX.4.64.0806091422180.16829@wrl-59.cs.helsinki.fi>
	 <a01a16b50806101626i2942ebam462410ad26050829@mail.gmail.com>
	 <Pine.LNX.4.64.0806111636330.16829@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5J0Uqfq002846

2008/6/11 Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi>:> On Wed, 11 Jun 2008, HÃ¥kon LÃ¸vdal wrote:>> I do not have any good explanation (bad memory?). When checking the>> copytest003.capture.bz2 file in the http server storage directory>> I get the same results as you. However I also have the original file>> stored still and comparing them with cmp -l gives>>  20558656 124 104>> so obviously a bit has been flipped.>> ...Yeah, which is a bad thing because now we don't know if that same error> causes the TCP stops too.>>> I have now replaced the erroneous file with a good copy, so you should>> be able to download again.>> I'll have a look if there's some common denominator but this whole issue> might well be due to hw failure.>
Hi. I tested the old pc with memtest86 and memtest86+ for 16 and 50hours without any errors detected, so apparently the ram is ok.
I now just did another test from a freshley booted old pc, standingidle for around 2 hours before I started the testing (no network activitybefore I plugged in the cable just before starting testing).
The copying failed after just 2.62GB, so the logs are short andnice. Stored on same server as earlier, new 2008-06-19 directory. Onething I noticed in the dmesg output on the old pc was the following:
BUG: unable to handle kernel paging request at virtual address ffff3cffprinting eip: ffff3cff *pde = 00793067 *pte = 00000000Oops: 0000 [#1] PREEMPTModules linked in: ...Pid: 18103, comm: sshd Not tainted (2.6.24-gafd564a8 #4)...Call Trace: [<f8c45b39>] nf_conntrack_find_get+0x36/0x3a [nf_conntrack] [<f8c46379>] nf_conntrack_in+0x135/0x3e8 [nf_conntrack] [<c0423c5d>] local_bh_disable+0xa/0xb [<c0626d54>] _read_lock_bh+0x12/0x1a...
BR HÃ¥kon LÃ¸vdalÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

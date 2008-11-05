Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYKEGqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYKEGqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 01:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbYKEGpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 01:45:54 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2602 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYKEGpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 01:45:53 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Michael Chan" <mchan@broadcom.com>
To: "'Eric Dumazet'" <dada1@cosmosbay.com>,
       "linux kernel" <linux-kernel@vger.kernel.org>,
       "Linux Netdev List" <netdev@vger.kernel.org>
Date: Tue, 4 Nov 2008 22:45:43 -0800
Subject: Re: [BUG] linux-2.6.28-rc3 regression: IRQ smp_affinities not
 respected
Thread-Topic: [BUG] linux-2.6.28-rc3 regression: IRQ smp_affinities not
 respected
Thread-Index: Ack/EHT9A7h3Tc2dQT+crRbfrMUnywAAIoDg
Message-ID: <C27F8246C663564A84BB7AB343977242151F4B18B5@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <49113E31.8080106@cosmosbay.com>
Accept-Language: en-US
Content-Language: en-US
acceptlanguage: en-US
MIME-Version: 1.0
X-OriginalArrivalTime: 05 Nov 2008 06:45:43.0947 (UTC)
 FILETIME=[203B05B0:01C93F12]
X-WSS-ID: 650F9E9237G9034964-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

> Hi all
>
> One more problem it seems on 2.6.28-rc3
>
> I wanted to get maximal throughput from my machine on a
> network bench with 3 Gigabit
> links delivering 600.000 packets per second, so I tried to
> play with smp_affinity to
> dedicate one CPU for each NIC.
>
> It worked with 2.6.27, so there is a regression on this part.

I believe this may be the patch that broke it:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ce6fce4295ba727b36fdc73040e444bd1aae64cd

I don't remember all the details, but the Broadcom 5708 chip is
affected because it does not support MSI per-vector masking.

One way to get around is to disable MSI with bnx2 parameter
disable_msi=1.



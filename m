Return-Path: <linux-kernel-owner+w=401wt.eu-S1030351AbXCVKET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351AbXCVKET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 06:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030342AbXCVKET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 06:04:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030339AbXCVKER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 06:04:17 -0400
Message-ID: <4602548E.20004@redhat.com>
Date: Thu, 22 Mar 2007 11:03:58 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Marti Raudsepp <marti@juffo.org>
CC: linux-kernel@vger.kernel.org, fsdevel <linux-fsdevel@vger.kernel.org>,
       device-mapper development <dm-devel@redhat.com>,
       Andrew Morton <akpm@osdl.org>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: BUG: Files corrupt after moving LVM volume to USB disk
References: <2a12af650703200334u2b94bbcbt2aab8e94b6f2a527@mail.gmail.com>
In-Reply-To: <2a12af650703200334u2b94bbcbt2aab8e94b6f2a527@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Marti Raudsepp wrote:
> This is a reproducible demonstration of the problem initially reported in my
> first e-mail, titled "PROBLEM: 'bio too big device' after moving to a USB
> disk" (http://lkml.org/lkml/2007/3/7/657)
...
> 06. Observe "bio too big device dm-0 (256 > 240)" messages in dmesg
> 
> [non]# dmesg |tail -n7
> [101403.106825] bio too big device dm-0 (256 > 240)
> [101403.115228] bio too big device dm-0 (256 > 240)
> [101403.115912] bio too big device dm-0 (256 > 240)
> [101403.130529] bio too big device dm-0 (256 > 240)
> [101403.131220] bio too big device dm-0 (256 > 240)
> [101403.141577] bio too big device dm-0 (256 > 240)
> [101403.142255] bio too big device dm-0 (256 > 240)

if (unlikely(bio_sectors(bio) > q->max_hw_sectors)) {
	printk("bio too big device %s (%u > %u)\n", 
...

Please could you try if this patch helps ?
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-merge-max_hw_sector.patch


Milan
--
mbroz@redhat.com

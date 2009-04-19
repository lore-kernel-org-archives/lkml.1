Return-Path: <linux-kernel-owner+w=401wt.eu-S1760906AbZDSMoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906AbZDSMoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 08:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758961AbZDSMoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 08:44:15 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:50082 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069AbZDSMoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 08:44:15 -0400
Message-ID: <49EB1C9C.3000105@msgid.tls.msk.ru>
Date: Sun, 19 Apr 2009 16:44:12 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: =?UTF-8?B?Um9nw6lyaW8gQnJpdG8=?= <rbrito@ime.usp.br>,
       linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB1A33.7050808@rtr.ca>
In-Reply-To: <49EB1A33.7050808@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
[]
> Nearly all of the hdparm flags work fine with libata and SATA/PATA drives.
> Among the *very few* that do not, are the -m and -d flags.  -c will be 
> working
> in the newest kernels, but not yet in most distro kernels.
> 
> The -d flag is not permitted by libata, as the kernel prefers to completely
> dictate DMA / PIO, and it does do a rather good job of it.

Well, the kernel does a good job here in *almost* all cases.
The problematic case is when a device has some bad/unreadable
blocks/sectors.  When such a place occurs on read, libata
(or whatever it is) performs several retries, each time
using "less aggressive" settings - like reducing UDMA and
PIO mode till the lowest possible PIO/33.  And the device
stays in that mode until reboot, even if the problematic
sector has been relocated.  So it'd be nice to be able to
reset the mode back in such cases.

/mjt

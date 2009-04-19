Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbZDSMeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbZDSMeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 08:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbZDSMd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 08:33:58 -0400
Received: from rtr.ca ([76.10.145.34]:47880 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757442AbZDSMd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 08:33:57 -0400
Message-ID: <49EB1A33.7050808@rtr.ca>
Date: Sun, 19 Apr 2009 08:33:55 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: =?UTF-8?B?Um9nw6lyaW8gQnJpdG8=?= <rbrito@ime.usp.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br>
In-Reply-To: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogério Brito wrote:
> Dear people,
> 
> I have one small question regarding the libata drivers and the 
> interaction with hdparm.
> 
> I am presently using PATA/IDE devices only, but some distributions 
> provide kernels with libata by default (and some defconfigs also use 
> libata even for IDE devices).
> 
> Using the usual IDE drivers, I can use/query various parameters with 
> hdparm, like, for instance, the -m option, the -c option or even 
> disabling DMA. With the libata drivers, this is all that I get:
..
> Am I doing something incorrectly? I would like at least to understand 
> what is happening and, if possible, to fine-tune some settings.
..

Nearly all of the hdparm flags work fine with libata and SATA/PATA drives.
Among the *very few* that do not, are the -m and -d flags.  -c will be working
in the newest kernels, but not yet in most distro kernels.

The -d flag is not permitted by libata, as the kernel prefers to completely
dictate DMA / PIO, and it does do a rather good job of it.

The -m flag could be done, and I even have code in hdparm to do it,
but libata is very buggy with multi-sector I/O, so -m is currently is disallowed.

Cheers

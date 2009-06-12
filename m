Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZFLWii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZFLWii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZFLWib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:38:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57012 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbZFLWia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:38:30 -0400
Message-ID: <4A32D8E0.5090900@zytor.com>
Date: Fri, 12 Jun 2009 15:38:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Harvey Chapman <hchapman-linux-kernel@3gfp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Matching hard disks to BIOS boot order
References: <4A31D8E8.4090200@3gfp.com> <20090612085341.04ffcae2@lxorguk.ukuu.org.uk>
In-Reply-To: <20090612085341.04ffcae2@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 12 Jun 2009 00:26:16 -0400
> Harvey Chapman <hchapman-linux-kernel@3gfp.com> wrote:
> 
>> Is there a way to figure out which hard disks match the BIOS boot order?
>>
>> I'm trying to tell a Linux program which disk to use based on the disk 
>> numbers (0,1,...) used by Windows. The best solution I've found so far 
>> is disk serial number, but that hasn't been terribly reliable for other 
>> reasons.
> 
> There is a BIOS interface for this on newer systems, although the kernel
> doesn't capture enough data to make it completely reliable below EDD 3.0
> (in theory if we grabbed a few more bits we could do EDD 1.x as well)
> 
> Most PCs today do EDD 3.0 however
> 

Actually, the best option is to completely forget about BIOS boot order
-- on some systems it can literally change from one boot to the next --
and instead rely on MBR signatures.  As far as I know, Windows requires
all hard drives to have unique signatures and will "rebrand" the disks
to make it so if necessary.

The MBR signature is 4 bytes starting at offset 440 decimal.

	-hpa

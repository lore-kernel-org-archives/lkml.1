Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbYBORhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbYBORhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYBORgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:36:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:47343 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYBORgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:36:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Oz0qbwwfwD6YL4DJZaCJ/JouNIoLJiK419Ig1XykyN3wNcaYfiP4z5d1fKyE8yy/PcQscyvdxYN2MEebWRKzzvpk1dvGYEwhJSatOy6QS0+oxr1d/Jjfv0vy5885GNHr0Jckf5U4paKby4/KNsS6xVPEYhekcq8NdzIXkxdnLUg=
Message-ID: <47B5CD99.5010301@gmail.com>
Date: Fri, 15 Feb 2008 11:36:25 -0600
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: Disk schedulers
References: <20080214162104.GA5347@ics.muni.cz> <Pine.LNX.4.64.0802151541370.30301@fbirervta.pbzchgretzou.qr> <20080215155922.GD4269@ics.muni.cz>
In-Reply-To: <20080215155922.GD4269@ics.muni.cz>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> On Fri, Feb 15, 2008 at 03:42:58PM +0100, Jan Engelhardt wrote:
>> Also consider
>> - DMA (e.g. only UDMA2 selected)
>> - aging disk
> 
> it's not the case.
> 
> hdparm reports udma5 is used, if it is reliable with libata.
> 
> The disk is 3 months old, kernel does not report any errors. And it has never 
> been different.
> 

A new current ide/sata disk should do around 60mb/second, check the
min/max bps rate listed on the disk companies site, and divide by 8, and
take maybe 80% of that

Also you may consider using the -l option on the scp command to limit
its total usage.

This feature has been around at least 8 years (from 2.2) that high
levels of writes would significantly starve out reads, mainly because
you can queue up 1000's of writes, and a read, when the read
finishes there are another 1000's writes for the next read to
get in line behind, and wait, and this continues until the
writes stop.

                                 Roger

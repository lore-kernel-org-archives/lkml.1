Return-Path: <linux-kernel-owner+w=401wt.eu-S932731AbYBNB0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731AbYBNB0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757565AbYBNB0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:26:20 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:47955 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447AbYBNB0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:26:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QKgzI53y9aXP2HbiKBy+64hBcuTVqu2lqfKdrVtPp1+9wSPipTdVkWSxnUowbenhz+OxAcXpTHaB2TA7/vAzkpzZNG/DhFN8rGU12ZDVe5zfvEhufnHT+Xkmi2msrVT1I8BG4xQvdZma/ztGHzkdIGKCKsXk6s+CgifKqpe9/iI=
Message-ID: <47B398B3.40308@gmail.com>
Date: Thu, 14 Feb 2008 10:26:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, jengelh@computergmbh.de,
       matthew@wil.cx, randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk,
 take #3
References: <12028937731333-git-send-email-htejun@gmail.com>	<20080213155701.48871761.akpm@linux-foundation.org>	<47B38E13.1060503@gmail.com> <20080213170950.86945835.akpm@linux-foundation.org>
In-Reply-To: <20080213170950.86945835.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
> On Thu, 14 Feb 2008 09:40:51 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Can you please take a look at ata_eh_link_report() in
>> drivers/ata/libata-eh.c?
> 
> I did.  Punishment?

Heh.. :-)

>>  Currently, it has some problems.
> 
> Yes, and the patches do clean that up.

Yeap, it does.

> ho hum.  What tends to happen with this sort of thing is that fi we merge
> it, it ends up getting used more often than one expected...

Hmmm... Okay.  mprintk being printk, I'm not too sure how it can go over
usual expectations but well, yeah, that actually is my expectation.

> If you stand back and squint at it, there are quite a few places where we
> do this sort of thing: allocate a buffer, squirt characters into it,
> reallocating and/or flushing as we proceed.  All sysfs and procfs read-side
> code, for a start...

printk is a special case, I think.  It's the primary logging/debugging
method which can't fail and as it's mostly interpreted by human beings
(and developers in problematic cases), it has different maneuvering room
on errors - ie. it's far better to print messages w/o header or proper
log level than failing to print, which is quite different requirements
from other components.

Thanks.

-- 
tejun

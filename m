Return-Path: <linux-kernel-owner+w=401wt.eu-S1761736AbYBOBtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761736AbYBOBtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 20:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYBOBtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 20:49:40 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:63546 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYBOBtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:49:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BMrMsLRb1Pn+AlihZolV20/aAFFTpvT2Lg1095nPC3ZRuUVfC4YsHtykzoC3BW26kI/Fe4Oo98BawRB3ODJW9Jz2UojPZbSEVA8cSRGca85tkcmmtsRwdBb7lDlIb8umIA/bn6oFT8O2MlS7i/piyGMwrlE9rs90KB4tNkrAq78=
Message-ID: <47B4EFAB.2040102@gmail.com>
Date: Fri, 15 Feb 2008 10:49:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, jengelh@computergmbh.de,
       matthew@wil.cx, randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk,
 take #3
References: <12028937731333-git-send-email-htejun@gmail.com>	<20080213155701.48871761.akpm@linux-foundation.org>	<47B38E13.1060503@gmail.com> <20080213170950.86945835.akpm@linux-foundation.org> <47B398B3.40308@gmail.com>
In-Reply-To: <47B398B3.40308@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Andrew Morton wrote:
>> On Thu, 14 Feb 2008 09:40:51 +0900
>> Tejun Heo <htejun@gmail.com> wrote:
>>
>>> Can you please take a look at ata_eh_link_report() in
>>> drivers/ata/libata-eh.c?
>> I did.  Punishment?
> 
> Heh.. :-)
> 
>>>  Currently, it has some problems.
>> Yes, and the patches do clean that up.
> 
> Yeap, it does.
> 
>> ho hum.  What tends to happen with this sort of thing is that fi we merge
>> it, it ends up getting used more often than one expected...
> 
> Hmmm... Okay.  mprintk being printk, I'm not too sure how it can go over
> usual expectations but well, yeah, that actually is my expectation.
> 
>> If you stand back and squint at it, there are quite a few places where we
>> do this sort of thing: allocate a buffer, squirt characters into it,
>> reallocating and/or flushing as we proceed.  All sysfs and procfs read-side
>> code, for a start...
> 
> printk is a special case, I think.  It's the primary logging/debugging
> method which can't fail and as it's mostly interpreted by human beings
> (and developers in problematic cases), it has different maneuvering room
> on errors - ie. it's far better to print messages w/o header or proper
> log level than failing to print, which is quite different requirements
> from other components.

Andrew, any more comments or suggestions on how to proceed on this?  One
way or the other, I think this is a problem worth solving.

Thanks.

-- 
tejun

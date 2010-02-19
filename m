Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab0BSAA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:00:58 -0500
Received: from mail-yx0-f180.google.com ([209.85.210.180]:62358 "EHLO
	mail-yx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab0BSAA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:00:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kuEs6eexBkLA5mWYtHwFiCFKgI089Yvti2Y/cCR8nwfoHppNYyP54VQDS2UBxZYDer
         6ciApedhfjPWXe5b2KSoVU8Vzy5RiIQNGSeWgOWRTPpkuZ6FImQ7Jz1gRoPgo58BMKwx
         F3r/ZcrZszwFfoGa1FIf4JgJADc1ekggWYyjg=
Message-ID: <4B7DD4B5.7000108@garzik.org>
Date: Thu, 18 Feb 2010 19:00:53 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] libata: pass host flags into __ata_pci_sff_init_one()
 helper
References: <20100218185914.16594.61415.sendpatchset@localhost> <20100218185922.16594.98925.sendpatchset@localhost> <20100218214448.692552fd@lxorguk.ukuu.org.uk>
In-Reply-To: <20100218214448.692552fd@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 04:44 PM, Alan Cox wrote:
> On Thu, 18 Feb 2010 19:59:22 +0100
> Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>  wrote:
>
>> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>> Subject: [PATCH] libata: pass host flags into __ata_pci_sff_init_one() helper
>>
>> This was orginally proposed by Alan Cox but as a change
>> for ata_pci_sff_init_one() helper function instead of
>> __ata_pci_sff_init_one() one which casues needless churn
>> to all host drivers and accidentally breakes few host
>> drivers which are still on their way upstream.
>>
>> Allows parallel scan and the like to be set without
>> having to stop using the existing full helper functions.
>
> NAK - __ is for internal symbol names.
>
> I was split 50/50 on adding ata_pci_sff_init_one_flags() or similar but
> the churn, given its a one off and we can then add all sorts of other
> future flags without pain, seemed worth it.
>
> I'm ambivalent about whether its best to go with a new function name as
> you have or take the hit now (which seems sensible to me). Either way the
> __ naming is wrong for an external interface.

Your proposed patch from yesterday adding flags to each is fine. 
All-driver patches are just fine, as long as the need is demonstrated 
[and it is, in this case].


> Anyway I'd *hope* we can get>  50% of interfaces parallel scanning at
> which point it ceases to be more noise anyway !
>
> Jeff ?

Most hardware should support parallel scanning, sans caveats like 
chipsets that snoop SET FEATURES - XFER MODE (that command, and only 
that command, needs synchronization)

	Jeff




Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbXI0E7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbXI0E7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 00:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXI0E7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 00:59:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:29693 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbXI0E7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 00:59:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=iHCiiqDkiW8a30IYb0vG8bVjLXHPl3JO6FcqZXMEMThBzMB3rwH6dCVcrFMs9Hahyz6EuWGYsGRJbNAy5dWPxlaZqvLZPZQnbQ8T1HYElaVxcqMawvsijKZ/lA14O079FKnQIeMQJIB1Ot4G6iasdf9L19h0kirWTcWQQhSrBo8=
Message-ID: <46FB3843.2030708@gmail.com>
Date: Thu, 27 Sep 2007 13:57:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com> <46FB3793.9060607@gmail.com>
In-Reply-To: <46FB3793.9060607@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Torsten Kaiser wrote:
>> Comparing the driver/ata directory from rc3-mm1 and rc4-mm1 the
>> following change looked the most suspicions to me:
>> http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=blobdiff;f=drivers/ata/sata_sil24.c;h=3dcb223117be9739ee04d70b6bfc776a4b839a3f;hp=e0cd31aa8002350add53ba6ff07493e503275244;hb=020bc1bd8d369a77bd9379cd9763ac0057651753;hpb=8d4bdf8087e682df98bdb856f6ad451bf6d597e7
>>
>> That after rc4-mm1 the sata_sil24.c did not change anymore also
>> matches the occurrence of the error.
>>
>> To confirm my theorie I exchanged the sata_sil24.c from rc8-mm1 with
>> the version from rc3-mm1.
>> I was able to boot the resulting kernel successfully 5 times, without
>> the error happening again.
> 
> Thanks a lot for chasing down the problem.  The changed code is address
> initialization path and it's weird that it causes intermittent failures,
> not a consistent one.
> 
> Anyways, does the attached patch fix the problem?

If not, can you add printk of iomap[SIL24_PORT_BAR], offset, initialized
cmd_addr and scr_addr in the loop and see whether anything is different
between when the driver works and fails.

Thanks.

-- 
tejun

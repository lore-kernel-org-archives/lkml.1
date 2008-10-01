Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYJAHzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYJAHzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYJAHzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:55:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:56335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYJAHzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:55:39 -0400
Message-ID: <48E32C93.8060201@kernel.org>
Date: Wed, 01 Oct 2008 16:53:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org> <20080924105943.GB2094@anita> <20080925081848.GB2305@anita> <48DEA40D.40709@kernel.org> <20080930081257.GB18961@anita.doom> <48E232FC.1090902@kernel.org> <20080930151622.GC18961@anita.doom> <48E25831.4030505@kernel.org> <20081001073817.GA3098@anita.doom>
In-Reply-To: <20081001073817.GA3098@anita.doom>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Oct 2008 07:55:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Kletschke wrote:
> Am 2008-10-01 01:47 +0900 schrieb Tejun Heo:
>> Please apply the attached patch and see whether the problem goes
>> away.
> 
> I will take care of this this evening.
> 
>> Also, can you test whether hotplug works with the patch applied?
> 
> Erm... I never did Hotplug on SATA, should I plug out the Disk out of
> the Mainboard Connector to see what happens? I suspect I need another
> additional disk the or a live-usb linux with this Kernel...

Or you can boot into single mode, ro mount / with kernel messages
redirected to console and hot unplug/plug the root disk and see what
happens.

> Should this 
> 
>> diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
>> index 14601dc..18f81d2 100644
>> +++ b/drivers/ata/sata_nv.c
>> @@ -433,6 +433,7 @@ static struct ata_port_operations nv_nf2_ops = {
>>  	.inherits		= &nv_common_ops,
>>  	.freeze			= nv_nf2_freeze,
>>  	.thaw			= nv_nf2_thaw,
>> +	.hardreset		= ATA_OP_NULL,
>>  };
>>  
>>  static struct ata_port_operations nv_ck804_ops = {
> 
> go onto vanilla 2.6.27_rc7 WITH or withOUT
> sata_nv-reinstate-nv_hardreset.patch?

With.

Thanks.

-- 
tejun

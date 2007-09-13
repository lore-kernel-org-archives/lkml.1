Return-Path: <linux-kernel-owner+w=401wt.eu-S1763610AbXIMSBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763610AbXIMSBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 14:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXIMSBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 14:01:39 -0400
Received: from ox.emgs.com ([194.248.190.99]:35383 "EHLO ox.emgs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbXIMSBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 14:01:38 -0400
Message-ID: <46E97AFF.30202@pvv.org>
Date: Thu, 13 Sep 2007 20:01:35 +0200
From: Jon Ivar Rykkelid <jonry@pvv.org>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org> <46E94728.9050509@garzik.org> <46E951C6.1000403@pvv.org> <46E953D7.5070305@gmail.com>
In-Reply-To: <46E953D7.5070305@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resending, as my first attempts contained HTML and was blocked...

Tejun Heo wrote:
> Jon Ivar Rykkelid wrote:
>   
>> Thanks for the suggestion, but sata_nv is not built modular in my
>> current kernel, so "no can do" at the moment
>> (However, if some expert REALLY thinks this will fix things, I will
>> CERTAINLY recompile and give it a go)
>>     
>
> Passing "sata_nv.adma=0" as kernel boot parameter will do the trick.
>
>   
Ahh, silly me... Of course!
Ooops, I just got back, and verified: I actually have sata_nv running as 
a module after all on this server... My bad.
I fixed /etc/modprobe.conf to include the following two lines:
"
alias scsi_hostadapter sata_nv
options sata_nv adma=0
...
"

I then ran "mkinitrd" (to ensure that the latest options from 
modprobe.conf were included) in the initrd-image that I load at boot.

- Do you guys think this is worth a try? Anyway, I have rebooted now, so 
I'll test it for a few days and let you know - We'll just have to wait 
and see...
Do you think I should re-enable SMART to provoke a failure, or would 
that be to tempt fate too much? (For now I have not re-enabled SMART)

PS: Is there any way of testing / verifying that sata_nv is now running 
with this option? - I am pretty sure I have done it correctly, but I 
would still like to confirm that the proper option has been passed if 
possible.

Thanks
Jon Ivar


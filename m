Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYG2DfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYG2DfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbYG2De7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:34:59 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:4862 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbYG2De6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gdjk03yKYvLWnJNfv2O+tfQ4JCCyy5nipSEnpCTaIzLFhpeGWtvy68DJig4COhpWTQ
         w8LQ3BvxS8cdFjYAuoNls9FzX/CQBPjf8J9+kJHNjj8MDDzq9Wtm3pcD+COKM/GvaMXA
         ScynR8IXnOBMs8SpZyP8PQgZjI40q7pBHKvp4=
Message-ID: <386072610807282034j6f6292e7u84e0e0b25fcfab6a@mail.gmail.com>
Date: Tue, 29 Jul 2008 11:34:56 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>
Subject: Re: [PATCH 1/3] Blackfin EMAC Driver: add proper __devinit/__devexit markings
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <488DE3E9.3000703@teltonika.lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217169905-7055-1-git-send-email-cooloney@kernel.org>
	 <1217169905-7055-2-git-send-email-cooloney@kernel.org>
	 <488DE3E9.3000703@teltonika.lt>
X-Google-Sender-Auth: f5744934b24facef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:21 PM, Paulius Zaleckas
<paulius.zaleckas@teltonika.lt> wrote:
> Bryan Wu wrote:
>>
>> From: Mike Frysinger <vapier.adi@gmail.com>
>>
>> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/net/bfin_mac.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
>> index 4144343..17951cb 100644
>> --- a/drivers/net/bfin_mac.c
>> +++ b/drivers/net/bfin_mac.c
>> @@ -956,7 +956,7 @@ static int bfin_mac_close(struct net_device *dev)
>>        return 0;
>>  }
>>  -static int __init bfin_mac_probe(struct platform_device *pdev)
>> +static int __devinit bfin_mac_probe(struct platform_device *pdev)
>
> __init was OK here.
> __devinit is for hotplug devices
>
>>  {
>>        struct net_device *ndev;
>>        struct bfin_mac_local *lp;
>> @@ -1082,7 +1082,7 @@ out_err_probe_mac:
>>        return rc;
>>  }
>>  -static int bfin_mac_remove(struct platform_device *pdev)
>> +static int __devexit bfin_mac_remove(struct platform_device *pdev)
>
> __devexit is for hotplug, use __exit
>
>>  {
>>        struct net_device *ndev = platform_get_drvdata(pdev);
>>        struct bfin_mac_local *lp = netdev_priv(ndev);
>> @@ -1129,7 +1129,7 @@ static int bfin_mac_resume(struct platform_device
>> *pdev)
>>   static struct platform_driver bfin_mac_driver = {
>>        .probe = bfin_mac_probe,
>
> .probe shouldn't be declared here. And you should use
> platform_device_probe() instead of platform_device_add()
>

I failed to find platform_device_probe. Could you please provide some info?
.probe and .remove is very common in platform driver interface, isn't?
I don't know any difference between platform_device_probe() and
platform_device_add().

Thanks
-Bryan

>> -       .remove = bfin_mac_remove,
>> +       .remove = __devexit_p(bfin_mac_remove),
>
> should be __exit_p()
>
>>        .resume = bfin_mac_resume,
>>        .suspend = bfin_mac_suspend,
>>        .driver = {
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

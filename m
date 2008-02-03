Return-Path: <linux-kernel-owner+w=401wt.eu-S936582AbYBCBzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936582AbYBCBzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 20:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936360AbYBCByE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 20:54:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56121 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S936352AbYBCByA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 20:54:00 -0500
Message-ID: <47A51E86.8080305@cn.fujitsu.com>
Date: Sun, 03 Feb 2008 09:53:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?UTF-8?B?TWlndWVsIEJvdMOzbg==?= <mboton@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>, zambrano@broadcom.com,
       linville@tuxdriver.com
Subject: Re: linux-2.6.24 compile error in drivers/net/b44.c
References: <47A3CC70.8090900@cn.fujitsu.com> <47A3F6DC.1000903@cn.fujitsu.com> <47A4CB7C.3010507@gmail.com>
In-Reply-To: <47A4CB7C.3010507@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Botón 写道:
> Li Zefan wrote:
>> Add CCs:
>>
>> CC: mboton@gmail.com
>> CC: zambrano@broadcom.com
>> CC: linville@tuxdriver.com
>>
>> Li Zefan wrote:
>>> drivers/net/b44.c: In function 'b44_remove_one':
>>> drivers/net/b44.c:2231: error: implicit declaration of function 'ssb_pcihost_set_power_state'
>>> make[2]: *** [drivers/net/b44.o] Error 1
>>> make[1]: *** [drivers/net] Error 2
>>>
>>> I think it is caused by:
>>>
>>> CONFIG_SSB_PCIHOST=n
>>> CONFIG_B44=y
>>>
>>
> 
> This patch should fix b44 errors when 'SSB_PCIHOST' is not enabled.
> 

I tried the patch, but it does't work, same compile error. :(

If .config is needed, tell me and I will attach it.

> Signed-off-by: Miguel Botón <mboton@gmail.com>
> 
> diff --git a/drivers/net/b44.c b/drivers/net/b44.c
> index ea2a2b5..d081234 100644
> --- a/drivers/net/b44.c
> +++ b/drivers/net/b44.c
> @@ -2228,7 +2228,9 @@ static void __devexit b44_remove_one(struct ssb_device *sdev)
>  	unregister_netdev(dev);
>  	ssb_bus_may_powerdown(sdev->bus);
>  	free_netdev(dev);
> +#ifdef B44_PCI
>  	ssb_pcihost_set_power_state(sdev, PCI_D3hot);
> +#endif
>  	ssb_set_drvdata(sdev, NULL);
>  }
>  
> @@ -2257,7 +2259,9 @@ static int b44_suspend(struct ssb_device *sdev, pm_message_t state)
>  		b44_setup_wol(bp);
>  	}
>  
> +#ifdef B44_PCI
>  	ssb_pcihost_set_power_state(sdev, PCI_D3hot);
> +#endif
>  	return 0;
>  }
>  
> --
> 	Miguel Botón
> 
> 



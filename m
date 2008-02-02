Return-Path: <linux-kernel-owner+w=401wt.eu-S934102AbYBBUAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbYBBUAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933450AbYBBUAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:00:15 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:59771 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbYBBUAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:00:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=sCHGnVnES3GQp1Vz2GnQPJ42ARvKi/uHgin887Dl1uOExG4PSIFO1L9hzr4KgRoMPyuYtU0Bxrg3+GM+2vZvFcAME0fiBxGAZdfHGdmQg65g5vedsLxWNZWXAtaEIdZY5j+IUlAOv3CN6v+HJxaML+Bnq5IOpscU5ruiDdQT5pQ=
Message-ID: <47A4CB7C.3010507@gmail.com>
Date: Sat, 02 Feb 2008 20:58:52 +0100
From: =?UTF-8?B?TWlndWVsIEJvdMOzbg==?= <mboton@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>, zambrano@broadcom.com,
       linville@tuxdriver.com
Subject: Re: linux-2.6.24 compile error in drivers/net/b44.c
References: <47A3CC70.8090900@cn.fujitsu.com> <47A3F6DC.1000903@cn.fujitsu.com>
In-Reply-To: <47A3F6DC.1000903@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Add CCs:
> 
> CC: mboton@gmail.com
> CC: zambrano@broadcom.com
> CC: linville@tuxdriver.com
> 
> Li Zefan wrote:
>> drivers/net/b44.c: In function 'b44_remove_one':
>> drivers/net/b44.c:2231: error: implicit declaration of function 'ssb_pcihost_set_power_state'
>> make[2]: *** [drivers/net/b44.o] Error 1
>> make[1]: *** [drivers/net] Error 2
>>
>> I think it is caused by:
>>
>> CONFIG_SSB_PCIHOST=n
>> CONFIG_B44=y
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

This patch should fix b44 errors when 'SSB_PCIHOST' is not enabled.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index ea2a2b5..d081234 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -2228,7 +2228,9 @@ static void __devexit b44_remove_one(struct ssb_device *sdev)
 	unregister_netdev(dev);
 	ssb_bus_may_powerdown(sdev->bus);
 	free_netdev(dev);
+#ifdef B44_PCI
 	ssb_pcihost_set_power_state(sdev, PCI_D3hot);
+#endif
 	ssb_set_drvdata(sdev, NULL);
 }
 
@@ -2257,7 +2259,9 @@ static int b44_suspend(struct ssb_device *sdev, pm_message_t state)
 		b44_setup_wol(bp);
 	}
 
+#ifdef B44_PCI
 	ssb_pcihost_set_power_state(sdev, PCI_D3hot);
+#endif
 	return 0;
 }
 
--
	Miguel Botón

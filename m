Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbYELRbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbYELRbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbYELRbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 13:31:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:46503 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755451AbYELRbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 13:31:09 -0400
X-Authenticated: #476490
X-Provags-ID: V01U2FsdGVkX1+9dWUEtqy92Wyx9LngOBkA9uha7z15AUr0N+Wv6a
	R277pgIEqb+0aM
From: Oliver Endriss <o.endriss@gmx.de>
Organization: ESCAPE GmbH EDV-Loesungen
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump firmware build error fix
Date: Mon, 12 May 2008 19:30:10 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>,
       Johannes Stezenbach <js@linuxtv.org>
References: <20080512101231.GA11755@elte.hu>
In-Reply-To: <20080512101231.GA11755@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805121930.10909@orion.escape-edv.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> x86.git testing found the following build failure in 2.6.26-rc2:
> 
>   drivers/media/dvb/ttpci/fdump "/usr/lib/hotplug/firmware/dvb-ttpci-01.fw" dvb_ttpci_fw drivers/media/dvb/ttpci/av7110_firm.h
>   firmware file '/usr/lib/hotplug/firmware/dvb-ttpci-01.fw' not found
>   make[4]: *** [drivers/media/dvb/ttpci/av7110_firm.h] Error 255
>   make[3]: *** [drivers/media/dvb/ttpci] Error 2
> 
> in this config:
> 
>   http://redhat.com/~mingo/misc/config-Mon_May_12_11_29_29_CEST_2008.bad
> 
> the reason for the build bug is that the driver's Kconfig ignores the 
> PREVENT_FIRMWARE_BUILD=y config setting and tries to build the firmware 
> which (like other firmware build methods) relies on a non-upstream 
> firmware blob. The fix is to make the firmware build depend on 
> !PREVENT_FIRMWARE_BUILD.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/media/dvb/ttpci/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/media/dvb/ttpci/Kconfig
> ===================================================================
> --- linux.orig/drivers/media/dvb/ttpci/Kconfig
> +++ linux/drivers/media/dvb/ttpci/Kconfig
> @@ -33,7 +33,7 @@ config DVB_AV7110
>  
>  config DVB_AV7110_FIRMWARE
>  	bool "Compile AV7110 firmware into the driver"
> -	depends on DVB_AV7110 && !STANDALONE
> +	depends on DVB_AV7110 && !STANDALONE && !PREVENT_FIRMWARE_BUILD
>  	default y if DVB_AV7110=y
>  	help
>  	  The AV7110 firmware is normally loaded by the firmware hotplug manager.
> 

Nak. because DVB_AV7110_FIRMWARE=y does not build any firmware.

If you set DVB_AV7110_FIRMWARE=y, the firmware file under
DVB_AV7110_FIRMWARE_FILE must exist...

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

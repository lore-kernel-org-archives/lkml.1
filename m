Return-Path: <linux-kernel-owner+w=401wt.eu-S1761670AbYETIH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761670AbYETIH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYETIHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:07:18 -0400
Received: from zm1.veloxia.com ([213.149.227.2]:41664 "HELO zm1.veloxia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753724AbYETIHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:07:16 -0400
Message-ID: <483286AF.2090302@hvsistemas.es>
Date: Tue, 20 May 2008 10:07:11 +0200
From: Javier Herrero <jherrero@hvsistemas.es>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Bryan Wu <cooloney@kernel.org>
Subject: Re: b4aa54d951d38d7a989d6b6385494ef5ea7371d7 breaks some serial configurations
References: <20080520073556.GA1090@flint.arm.linux.org.uk>
In-Reply-To: <20080520073556.GA1090@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does the problem arise due to the change of inclusion order of 
asm/serial.h (from after 8250.h to before 8250.h) ?

Russell King escribió:
> The above commit contains the following patch:
>
> | --- a/drivers/serial/8250.c
> | +++ b/drivers/serial/8250.c
> | @@ -43,6 +43,7 @@
> | 
> |  #include <asm/io.h>
> |  #include <asm/irq.h>
> | +#include <asm/serial.h>
> | 
> |  #include "8250.h"
> | 
> | @@ -92,8 +93,6 @@ static unsigned int nr_uarts = CONFIG_SERIAL_8250_RUNTIME_UARTS;
> |   */
> |  #define CONFIG_HUB6 1
> | 
> | -#include <asm/serial.h>
> | -
> |  /*
> |   * SERIAL_PORT_DFNS tells us about built-in ports that have no
> |   * standard enumeration mechanism.   Platforms that can find all
>
> The code between these two hunks contains the following:
>
> | #ifdef CONFIG_SERIAL_8250_DETECT_IRQ
> | #define CONFIG_SERIAL_DETECT_IRQ 1
> | #endif
> | #ifdef CONFIG_SERIAL_8250_MANY_PORTS
> | #define CONFIG_SERIAL_MANY_PORTS 1
> | #endif
>
> and asm-*/serial.h contains:
>
> | $ grep 'CONFIG_SERIAL_DETECT\|CONFIG_SERIAL_MANY' include/asm-*/serial.h
> | include/asm-alpha/serial.h:#ifdef CONFIG_SERIAL_DETECT_IRQ
> | include/asm-m68k/serial.h:#ifdef CONFIG_SERIAL_DETECT_IRQ
> | include/asm-mn10300/serial.h:#ifdef CONFIG_SERIAL_DETECT_IRQ
> | include/asm-mn10300/serial.h:#ifdef CONFIG_SERIAL_MANY_PORTS
> | include/asm-x86/serial.h:#ifdef CONFIG_SERIAL_DETECT_IRQ
>
> So, all these ifdefs are now useless.
>

-- 
------------------------------------------------------------------------
Javier Herrero                            EMAIL: jherrero@hvsistemas.com
HV Sistemas S.L.                          PHONE:         +34 949 336 806
Los Charcones, 17A                        FAX:           +34 949 336 792
19170 El Casar - Guadalajara - Spain      WEB: http://www.hvsistemas.com 


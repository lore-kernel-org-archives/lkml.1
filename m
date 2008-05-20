Return-Path: <linux-kernel-owner+w=401wt.eu-S1760952AbYETHk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760952AbYETHk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 03:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYETHkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 03:40:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43357 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbYETHkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 03:40:19 -0400
Date: Tue, 20 May 2008 08:35:56 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Javier Herrero <jherrero@hvsistemas.es>, Bryan Wu <cooloney@kernel.org>
Subject: b4aa54d951d38d7a989d6b6385494ef5ea7371d7 breaks some serial configurations
Message-ID: <20080520073556.GA1090@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The above commit contains the following patch:

| --- a/drivers/serial/8250.c
| +++ b/drivers/serial/8250.c
| @@ -43,6 +43,7 @@
| 
|  #include <asm/io.h>
|  #include <asm/irq.h>
| +#include <asm/serial.h>
| 
|  #include "8250.h"
| 
| @@ -92,8 +93,6 @@ static unsigned int nr_uarts = CONFIG_SERIAL_8250_RUNTIME_UARTS;
|   */
|  #define CONFIG_HUB6 1
| 
| -#include <asm/serial.h>
| -
|  /*
|   * SERIAL_PORT_DFNS tells us about built-in ports that have no
|   * standard enumeration mechanism.   Platforms that can find all

The code between these two hunks contains the following:

| #ifdef CONFIG_SERIAL_8250_DETECT_IRQ
| #define CONFIG_SERIAL_DETECT_IRQ 1
| #endif
| #ifdef CONFIG_SERIAL_8250_MANY_PORTS
| #define CONFIG_SERIAL_MANY_PORTS 1
| #endif

and asm-*/serial.h contains:

| $ grep 'CONFIG_SERIAL_DETECT\|CONFIG_SERIAL_MANY' include/asm-*/serial.h
| include/asm-alpha/serial.h:#ifdef CONFIG_SERIAL_DETECT_IRQ
| include/asm-m68k/serial.h:#ifdef CONFIG_SERIAL_DETECT_IRQ
| include/asm-mn10300/serial.h:#ifdef CONFIG_SERIAL_DETECT_IRQ
| include/asm-mn10300/serial.h:#ifdef CONFIG_SERIAL_MANY_PORTS
| include/asm-x86/serial.h:#ifdef CONFIG_SERIAL_DETECT_IRQ

So, all these ifdefs are now useless.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

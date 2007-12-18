Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbXLRNvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbXLRNvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 08:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbXLRNvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 08:51:23 -0500
Received: from [59.37.49.52] ([59.37.49.52]:45260 "EHLO mail2.micromark.com.cn"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756798AbXLRNvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 08:51:21 -0500
X-Greylist: delayed 1749 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2007 08:51:21 EST
In-Reply-To: <20071218113337.061a8e59@dhcp-252-066.norway.atmel.com>
References: <1197971591-23890-1-git-send-email-hskinnemoen@atmel.com> <3efb10970712180214g374749cbh940958e1eff7185c@mail.gmail.com> <20071218113337.061a8e59@dhcp-252-066.norway.atmel.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <25FA62D8-BCBE-4A0E-A98D-F883FB65AFBE@micromark.net.cn>
Cc: "Remy Bohmer" <linux@bohmer.net>, linux-kernel@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Content-Transfer-Encoding: 7bit
From: steve birtles <arm_kernel_development@micromark.net.cn>
Subject: Re: [PATCH v2] atmel_serial: Clean up the code
Date: Tue, 18 Dec 2007 21:22:01 +0800
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
X-Mailer: Apple Mail (2.752.2)
X-BitDefender-Scanner: Clean, Agent: BitDefender Smtp Proxy 2.0.0 on
 mail2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 18, 2007, at 6:33 PM, Haavard Skinnemoen wrote:

> On Tue, 18 Dec 2007 11:14:42 +0100
> "Remy Bohmer" <linux@bohmer.net> wrote:
>
>> Hello Haavard,
>>
>>> Please note that I'm not trying to steal the show here -- I just  
>>> want
>>
>> That did not even come to my mind at all...
>> I am happy with everything that helps making this driver better.
>
> Good :)
>
>> What shall we do first from here, splitup of the interrupt  
>> handler? Or
>> DMA patch?
>


Is there any change can we clean this up?
  /*
   * We wrap our port structure around the generic uart_port.
@@ -142,8 +146,8 @@ static void atmel_set_mctrl(struct uart_port  
*port, u_int mctrl)
  #ifdef CONFIG_ARCH_AT91RM9200
  	if (cpu_is_at91rm9200()) {
  		/*
-		 * AT91RM9200 Errata #39: RTS0 is not internally connected to PA21.
-		 *  We need to drive the pin manually.
+		 * AT91RM9200 Errata #39: RTS0 is not internally connected
+		 * to PA21. We need to drive the pin manually.
  		 */
  		if (port->mapbase == AT91RM9200_BASE_US0) {
  			if (mctrl & TIOCM_RTS)
@@ -228,7 +232,8 @@ static void atmel_stop_rx(struct uart_port *port)
   */

and potentially add those flags for  dealing with the  CTS & RTS   ,  
that may not be used on every board,  because this clean up sit's in  
my minor changes for the YL9200, specifically to  re-jig the USARTS  
lines so that we can separate  RXD TXD , from a forced requirment to  
use  control lines when using  232

Steve



> I currently have the patches applied in the order you sent them,  
> with my
> stuff wedged in between (thanks to git-rebase --interactive.) So I
> think it makes sense to do the interrupt handler splitup first, even
> though I personally care more about the DMA patch.
>
> Haavard
>
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux- 
> arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
>



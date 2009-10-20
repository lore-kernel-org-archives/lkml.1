Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbZJTPv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbZJTPv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 11:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZJTPv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 11:51:56 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52944 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbZJTPvz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 11:51:55 -0400
Message-Id: <1256053920.24677.1341041247@webmail.messagingengine.com>
X-Sasl-Enc: xpJK0wLWsBrKVgkMCuKnHX+i85v3Xs2FNyU64AlP/hhs 1256053920
From: myuboot@fastmail.fm
To: "Florian Fainelli" <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, "linux-mips" <linux-mips@linux-mips.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: MessagingEngine.com Webmail Interface
References: <1255735395.30097.1340523469@webmail.messagingengine.com>
 <4AD906D8.3020404@caviumnetworks.com>
 <1255996564.10560.1340920621@webmail.messagingengine.com>
 <200910200817.24018.florian@openwrt.org>
Subject: Re: serial port 8250 messed up after coverting from little endian to
 big endian on kernel  2.6.31
In-Reply-To: <200910200817.24018.florian@openwrt.org>
Date: Tue, 20 Oct 2009 10:52:00 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I happen to use the same code from ar7. So this part
serial_int/serial_out should be fine?

#define PORT(offset) (KSEG1ADDR(MY_MIPSBOARD_REGS_UART0 + (offset * 4)))
static inline unsigned int serial_in(int offset)
{
        return readl((void *)PORT(offset));
}

static inline void serial_out(int offset, int value)
{
        writel(value, (void *)PORT(offset));
}

Thanks. 



On Tue, 20 Oct 2009 08:17 +0200, "Florian Fainelli"
<florian@openwrt.org> wrote:
> Hi,
> 
> Le mardi 20 octobre 2009 01:56:04, myuboot@fastmail.fm a écrit :
> > I am trying to bringup a MIPS32 board using 2.6.31. It is working in
> > little endian mode. After changing the board's hardware from little
> > endian to bit endian, the serial port print messed up. It prints now
> > something like - "àààààààààààààààà" on the screen. When I trace the
> > execution, I can see the string the kernel is trying print is correct -
> > "Linux version 2.6.31 ..." and etc.
> > 
> > I guess it means the initialization of the serial port is not properly
> > done. But I am not sure where I should check for the problem. The serial
> > port device I am using is 8250. Please give me some advise.
> 
> If the same initialization routine used to work in little-endian, check
> how 
> you actually write and read characters from the UART FIFO and especially
> if 
> your hardware requires you to do word or byte access to these registers.
> 
> You can have a look at AR7, which has the same code working for Little
> and Big 
> Endian modes in arch/mips/ar7/prom.c lines 272 to the end of the file. It
> also 
> uses a 8250-compatible UART.

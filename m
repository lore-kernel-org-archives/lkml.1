Return-Path: <linux-kernel-owner+w=401wt.eu-S932730AbZJ1If4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbZJ1If4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932682AbZJ1If4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:35:56 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35616 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665AbZJ1Ifz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:35:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=waA70LkxkcQAnjDKZEexB7fdW0fn64BGDuAm1OALqd7q1ybc9Zz9x034kA1SLnBbFH
         7Hs5DqrTLxlpFZcXtZ4ytluFcoje13zmU3D2w8pREmRGlcCi2RCY+J13GYwlMCLiQrXC
         nDaYiShDhSfNqsUjCoLqKP+W60pIa5u/hHiMw=
Date: Wed, 28 Oct 2009 10:35:51 +0200
From: Shmulik Ladkani <jungoshmulik@gmail.com>
To: myuboot@fastmail.fm
Cc: "Florian Fainelli" <florian@openwrt.org>, linux-kernel@vger.kernel.org,
       "linux-mips" <linux-mips@linux-mips.org>, shmulik@jungo.com
Subject: Re: serial port 8250 messed up after coverting from little endian
 to big endian on kernel  2.6.31
Message-ID: <20091028103551.0b4052d8@pixies.home.jungo.com>
In-Reply-To: <1256676013.24305.1342273367@webmail.messagingengine.com>
References: <1255735395.30097.1340523469@webmail.messagingengine.com>
	<4AD906D8.3020404@caviumnetworks.com>
	<1255996564.10560.1340920621@webmail.messagingengine.com>
	<200910200817.24018.florian@openwrt.org>
	<1256676013.24305.1342273367@webmail.messagingengine.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 15:40:13 -0500 myuboot@fastmail.fm wrote:
> Thanks, Florian. I found the cause of the problem. My board is 32 bit
> based, so each serial port register is 32bit even only 8 bit is used. So
> when the board is switched endianess, I need to change the address
> offset to access the same registers.
> For example, original RHR register address is 0x8001000 with little
> endian mode. With big endian, I need to access it as 0x8001003.

I assume your uart_port's iotype is defined as UPIO_MEM32.
UPIO_MEM32 makes 8250 access serial registers using readl/writel (which might
be a problem for big-endian), while UPIO_MEM makes 8250 access the registers
using readb/writeb.
Maybe you should try UPIO_MEM (assuming hardware allows byte access).

-- 
Shmulik Ladkani		Jungo Ltd.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbXI2Aln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbXI2Aln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbXI2Alg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:41:36 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:22743 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXI2Alf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MQC5tkwej/aGbubsHK6/kOsI/kC2akuIQhrhTtH4ZLQBlvSF5d/mv2HdYazuopYSFYSgkezGxa4NLR6CmmrpvkaNVATaE3UIRlV4Ae2PocgrxQbVhMHeRMqaD7NhHja0Hd6V4WJ1DL+y65vZgXcqr80146VGE296+a70o0BrpiY=
Subject: Re: vga text console not working on 2.6.23-rc8
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Santiago Garcia Mantinan <manty@manty.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070928200352.GA2312@pul.manty.net>
References: <20070928200352.GA2312@pul.manty.net>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 08:41:28 +0800
Message-Id: <1191026488.5273.12.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 22:03 +0200, Santiago Garcia Mantinan wrote:
> Hi!
> 
> I have just compiled a 2.6.23-rc8 using the config from my 2.6.22 as a basis
> and I came out with a not working (almost black) vga text console.
> 
> This is what I'm getting on my logs:
> 
> Console: colour dummy device 80x25
> console [tty0] enabled
> 
> Instead of the old:
> 
> Console: colour VGA+ 80x25
> 
> The options related to the console on my config are these:
> 
> CONFIG_VT=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_VGA_CONSOLE=y
> CONFIG_VIDEO_SELECT=y
> CONFIG_DUMMY_CONSOLE=y
> 
> The machine is a AMD x64 X2 Athlon with a NForce 4 chipset, vga is a ATI
> radeon and I have also set:
> 
> CONFIG_DRM=m
> CONFIG_DRM_RADEON=m
> 
> I have tried with and without CONFIG_VIDEO_SELECT and
> CONFIG_VIDEO_OUTPUT_CONTROL with the same results. BTW: when X starts the
> display is Ok.
> 
> If you want me to do any tests or need more info just tell me.

Also insert this in drivers/video/console/vgacon.c as the first
statement of vgacon_startup()

printk("vgacon: ORIG_VIDEO_ISVGA %x ORIG_VIDEO_MODE %x ORIG_VIDEO_LINES
%x ORIG_VIDEO_COLS %x\n", ORIG_VIDEO_ISVGA, ORIG_VIDEO_MODE,
ORIG_VIDEO_LINES, ORIG_VIDEO_COLS);

Tony


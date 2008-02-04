Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbYBDK3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbYBDK3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbYBDK3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:29:04 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:40097 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYBDK3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:29:03 -0500
Date: Mon, 4 Feb 2008 11:29:01 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: ohyama_sec@ariel-networks.com
cc: linux-kernel@vger.kernel.org
Subject: Re: [QUESTION] I have a question about making device driver
In-Reply-To: <20080204095430.AFC6A978007@ns.ariel-networks.com>
Message-ID: <Pine.LNX.4.64.0802041121550.16441@fbirervta.pbzchgretzou.qr>
References: <20080204095430.AFC6A978007@ns.ariel-networks.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 4 2008 18:54, ohyama_sec@ariel-networks.com wrote:
>
>I'm writing device driver for parallel port on Linux.

Another one?

>In initial function which is argument of module_init() in my device
>driver, I reserved I/O address region, 0x378-0x37a, with using
>request_region() and regist my charactor device driver calling
>register_chrdev().
>
>After I compile and link it. I insert this module and I can confirm
>that I obtaind the range of I/O address at /proc/ioports. But I
>cannot write data on I/O address line, It means that following check
>program shows "false".

>--- check program ---
>#include <linux/types.h>
>#include <asm/io.h>
>#include <stdio.h>

A userspace program? I thought this was about kernel device drivers.

>int main(void){
>    int base = 0x378;
>    char read, write;
>
>    ioperm(base, 1, 1);
>
>    write = 0xa;
>    outb(write, base);
>    read = inb(base);
>    if((read & 0xf) == write){

Some parallel port chips always return 0 on inb(base), for example
the AMD K6 boards that shipped with VIA Apollo chipsets (1998). On
the other hand, a chipset as old as to carry a i386DX CPU (probably
was all Intel back then) returns the desired 0xA on inb(base).

>        printf("true\n");
>    }else{
>        printf("false\n");    
>    }
>    return 0;
>}

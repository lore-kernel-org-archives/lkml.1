Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbYBDKOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbYBDKOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 05:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYBDKOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 05:14:42 -0500
Received: from ns.ariel-networks.com ([124.39.57.10]:58647 "EHLO
	ns.ariel-networks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYBDKOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 05:14:41 -0500
X-Greylist: delayed 1210 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2008 05:14:41 EST
To: linux-kernel@vger.kernel.org
Subject: [QUESTION] I have a question about making device driver
Message-Id: <20080204095430.AFC6A978007@ns.ariel-networks.com>
Date: Mon,  4 Feb 2008 18:54:30 +0900 (JST)
From: ohyama_sec@ariel-networks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question about device driver.

I'm writing device driver for parallel port on Linux.

In initial function which is argument of module_init() in my device driver, I reserved I/O address region, 0x378-0x37a, with using request_region() and regist my charactor device driver calling register_chrdev().

After I compile and link it. I insert this module and I can confirm that I obtaind the range of I/O address at /proc/ioports.
But I cannot write data on I/O address line, It means that following check program shows "false".

--- check program ---
#include <linux/types.h>
#include <asm/io.h>
#include <stdio.h>

int main(void){
    int base = 0x378;
    char read, write;

    ioperm(base, 1, 1);

    write = 0xa;
    outb(write, base);
    read = inb(base);

    if((read & 0xf) == write){
        printf("true\n");
    }else{
        printf("false\n");    
    }
    return 0;
}
---

At this time, I unloaded kernel modules which are related to parallel port. they are 'ppdev', 'lp', 'parport_pc' and 'parport'.

What should I do at initial funtion in my module to do I/O.
(The version of kernel that I use is 2.6.19-7.)


===
by Hiroyasu Ohyama


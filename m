Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZF3SeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZF3SeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 14:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZF3Sd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 14:33:58 -0400
Received: from poseidon.ceid.upatras.gr ([150.140.141.169]:47256 "EHLO
	poseidon.ceid.upatras.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbZF3Sd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 14:33:57 -0400
X-Greylist: delayed 1553 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jun 2009 14:33:56 EDT
Message-ID: <4A4A5482.3050108@ceid.upatras.gr>
Date: Tue, 30 Jun 2009 21:08:02 +0300
From: Korkakakis Nikos <korkakak@ceid.upatras.gr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090504)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-newbie@vger.kernel.org
Subject: kmalloc returns twice  the same memory address?
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there all,

first of all I am writing a kernel module to handle some device using;
uname -a: Linux localhost 2.6.30-gentoo-r1 #1 SMP Sun Jun 28 02:52:23
EEST 2009 i686 AMD Phenom(tm) II X4 940 Processor AuthenticAMD GNU/Linux.
During  the init phase of the module I allocate some memory via
kmalloc() in the following manner;

    omm_dev_buffer = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA | GFP_ATOMIC);
    if (!omm_dev_buffer) {
        return -ENOMEM;
    }
    clear_buffer (omm_dev_buffer, PAGE_SIZE);
    printk("omm_dev_init: kmalloc'ed omm_dev_buffer OK\n");
    omm_messages = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
    printk ("dev_buff @ 0x%x messages @
0x%x\n",omm_dev_buffer,omm_messages);
    if (!omm_messages) {
        kfree(omm_dev_buffer); /* failing at this point means that the
other allocation succeeded */
        return -ENOMEM;
    }
    clear_buffer (omm_messages, PAGE_SIZE);


where clear_buffer is just a wrapper for memset. My problem is that the
two consecutive memory allocation operations return the same memory
space (both pointers point the same address). If I change the malloc'ed
size ie PAGE_SIZE*2 then the process works as expected. kzalloc behaves
the same way, while alloc_page with the same flags(i.e.
alloc_page(GFP_KERNEL | GFP_DMA | GFP_ATOMIC) ) return a different
memory space and works as expected.

What am I missing here?

Thank's in advance :D

Nikos

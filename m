Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbZIDKyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbZIDKyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZIDKya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:54:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59327 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785AbZIDKy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:54:29 -0400
Subject: is WARN_ON(irqs_disabled) in dma_free_coherent() spurious ??
From: Tony Olech <tony.olech@elandigitalsystems.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <inux-usb@vger.kernel.org>
Content-Type: text/plain
Organization: Elan Digital Systems
Date: Fri, 04 Sep 2009 11:52:34 +0100
Message-Id: <1252061554.6449.1552.camel@dell-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+9rViUChKSBCbUZVvZlHtWbOvRybVxjxvtXta
 nT7bAkab7d59kkr7gKrpYuH2YnFTZHVtlMKv7kDzWyUH8ZF6yy
 b8rDcz99NcT/Xh8X3mKjClHpN7UP55M8Qb+R/zxSJnWQTlty93
 iwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I am trying to develop a linux kernel driver for a USB
device and I am initially following the example driver
usb-skeleton.c and also the driver usblcd.c

The sequence:

in the file operation ..write():
  usb_alloc_urb()
  usb_buffer_alloc(a big buffer)
  usb_fill_bulk_urb(for an OUT pipe)
  usb_submit_urb()
  usb_free_urb()
then in the completion ..callback():
  usb_buffer_free()
the routine dma_free_coherent() is called which calls
  WARN_ON(irqs_disabled) 

and because I am running the kernel with all the debugs
and warnings switched on I get a stack dump in the system
log.

Because I do not want to see warnings unless I am doing
something wrong I have to investigate the (possible)
problem. As far as I can tell the WARN_ON() is completely
spurious. Is that correct?? If so what is the solution
and who will change the drivers that use the same algorithm??

Many thanks,

Tony Olech

Elan Digital Systems Ltd


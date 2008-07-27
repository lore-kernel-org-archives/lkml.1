Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbYG0KJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbYG0KJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 06:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYG0KJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 06:09:42 -0400
Received: from main.gmane.org ([80.91.229.2]:33012 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYG0KJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 06:09:41 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nikos Chantziaras <realnc@arcor.de>
Subject: Re: do_IRQ: 0.83/0.84 No irq handler for vector
Date: Sun, 27 Jul 2008 13:09:26 +0300
Message-ID: <g6hhgq$86g$1@ger.gmane.org>
References: <g6g1ct$6es$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: athedsl-49250.home.otenet.gr
User-Agent: Thunderbird 2.0.0.14 (X11/20080715)
In-Reply-To: <g6g1ct$6es$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikos Chantziaras wrote:
> Kernel 2.6.26 (on x86-64) gives "do_IRQ: 0.83 No irq handler for vector" 
> (and "do_IRQ: 0.83", but less often) warnings periodically.

I changed the kernel config:

   - CONFIG_PCI_MSI=y
   + # CONFIG_PCI_MSI is not set

In other words I disabled Message Signaled Interrupt support.  Now 
instead of "do_IRQ: 0.83 No irq handler for vector" I get:

   +------ PCI-Express Device Error ------+
   Error Severity          : Uncorrected (Non-Fatal)
   PCIE Bus Error type     : Transaction Layer
   Flow Control Protocol   : First
   Receiver ID             : 0010
   VendorID=1106h, DeviceID=a208h, Bus=00h, Device=02h, Function=00h
   Broadcast error_detected message
   Broadcast mmio_enabled message
   Broadcast resume message
   AER driver successfully recovered

(Repeated as many times as the "do_IRQ" message previously.)

In case someone needs it, this is my complete dmesg:

   http://realnc.pastebin.com/d6534029

and this is the kernel configuration: 
http://bugs.freedesktop.org/attachment.cgi?id=17912


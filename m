Return-Path: <linux-kernel-owner+w=401wt.eu-S1764935AbXGKREm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764935AbXGKREm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXGKREf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:04:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbXGKREe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:04:34 -0400
Message-ID: <46950D94.7050909@redhat.com>
Date: Wed, 11 Jul 2007 13:04:20 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [2.6.22-rc7] khubd NULL deref oops...
References: <6278d2220707081445s6c5029a6la5ae0fd019176f74@mail.gmail.com>
In-Reply-To: <6278d2220707081445s6c5029a6la5ae0fd019176f74@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2007 05:45 PM, Daniel J Blueman wrote:
> When plugging in a USB 2 mass-storage device which I've been seeing
> problems with, I caught a khubd oops [1]. Kernel is 2.6.22-rc7 on ia32
> built with Ubuntu's 2.6.22 .config.

> [ 4769.252000] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [ 4769.252000]  sdb: sdb1 < sdb5 sdb6<6>usb 5-3: reset high speed USB
> device using ehci_hcd and address 8

So the device got reset right in the middle of scanning for partitions.

> [ 4769.544000] usb 5-3: device descriptor read/64, error -71
> [ 4769.760000] usb 5-3: device descriptor read/64, error -71
> [ 4769.976000] usb 5-3: reset high speed USB device using ehci_hcd and
> address 8
> [ 4770.088000] usb 5-3: device descriptor read/64, error -71
> [ 4770.304000] usb 5-3: device descriptor read/64, error -71
> [ 4770.520000] usb 5-3: reset high speed USB device using ehci_hcd and
> address 8
> [ 4770.928000] usb 5-3: device not accepting address 8, error -71
> [ 4771.040000] usb 5-3: reset high speed USB device using ehci_hcd and
> address 8

Then a whole slew of these by-now-familiar messages.

Try disabling CONFIG_USB_SUSPEND.  It makes lots of USB bugs go away:

 - scanners apps work instead of displaying black preview screens
 - printers stop spontaneously disconnecting
 - USB storage devices mysteriously work again
 - Blackberries start charging when plugged in



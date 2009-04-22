Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbZDVRk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbZDVRk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZDVRkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:40:10 -0400
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:43854 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753006AbZDVRkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:40:09 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] usb/host/ohci-hcd.c: fix sparse warnings
Date: Wed, 22 Apr 2009 13:39:34 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090165EFC3@mi8nycmail19.Mi8.com>
In-Reply-To: <20090422055327.GF9009@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] usb/host/ohci-hcd.c: fix sparse warnings
Thread-Index: AcnDENFtp0u4Z33eQsCciGnRvkfIJAAXzjSA
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFC@mi8nycmail19.Mi8.com> <20090422055327.GF9009@kroah.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Greg KH" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Apr 2009 17:40:06.0939 (UTC) FILETIME=[603226B0:01C9C371]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 21, 2009 10:53 PM, Greg KH wrote:
> On Wed, Apr 15, 2009 at 10:04:17PM -0400, H Hartley Sweeten wrote:
> Fix sparse warnings in drivers/usb/host/ohci-hcd.c.
>> 
>> 	warning: symbol 'temp' shadows an earlier one
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> I'm not seeing this sparse warning either.
>
> And you didn't fix the two sparse warnings I am seeing in this file,
> so I'm going to think this patch doesn't really do anything :(

Following are the sparse warnings I am seeing when building for an
EP93xx ARM platform:

  CHECK   drivers/usb/host/ohci-hcd.c
drivers/usb/host/ohci-hcd.c:626:2: warning: symbol 'temp' shadows an
earlier one
drivers/usb/host/ohci-hcd.c:574:14: originally declared here
drivers/usb/host/ohci-hcd.c:634:4: warning: symbol 'temp' shadows an
earlier one
drivers/usb/host/ohci-hcd.c:574:14: originally declared here
drivers/usb/host/ohci-hcd.c:676:3: warning: symbol 'temp' shadows an
earlier one
drivers/usb/host/ohci-hcd.c:574:14: originally declared here
drivers/usb/host/ohci-hcd.c:724:2: warning: symbol 'temp' shadows an
earlier one
drivers/usb/host/ohci-hcd.c:574:14: originally declared here
drivers/usb/host/ohci-q.c:69:2: warning: context imbalance in
'finish_urb': __context__ statement expected different context
drivers/usb/host/ohci-q.c:69:2:    context '<noident>': wanted >= 0, got
-1
drivers/usb/host/ohci-q.c:991:15: warning: context problem in
'finish_unlinks': 'finish_urb' expected different context
drivers/usb/host/ohci-q.c:991:15:    context 'lock': wanted >= 1, got 0
drivers/usb/host/ohci-q.c:1082:13: warning: context problem in
'takeback_td': 'finish_urb' expected different context
drivers/usb/host/ohci-q.c:1082:13:    context 'lock': wanted >= 1, got 0
drivers/usb/host/ohci-hcd.c:298:14: warning: context problem in
'ohci_urb_dequeue': 'finish_urb' expected different context
drivers/usb/host/ohci-hcd.c:298:14:    context 'lock': wanted >= 1, got
0

All the 'temp' shadows warnings appear to be caused by the
raw_local_irq_disable() macro in arch/arm/include/asm/irqflags.h.

I have no idea how to fix the context imbalance warnings so I left
those alone. The functions seem to be tagged correctly with __releases()
and __acquires() as needed. Could those be a problem with sparse?

> thanks,
> 
> greg k-h

Regards,
Hartley

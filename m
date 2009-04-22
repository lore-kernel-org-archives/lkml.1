Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZDVRZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZDVRZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZDVRZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:25:44 -0400
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:44633 "HELO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751291AbZDVRZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:25:43 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH]  usb/core/hub.c: fix sparse warnings
Date: Wed, 22 Apr 2009 13:25:32 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090165EFB9@mi8nycmail19.Mi8.com>
In-Reply-To: <20090422055118.GE9009@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH]  usb/core/hub.c: fix sparse warnings
Thread-Index: AcnDENEXZEazks3mQCyIKgKQBxZi8QAW+7Ow
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8DF9@mi8nycmail19.Mi8.com> <20090422055118.GE9009@kroah.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Greg KH" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Apr 2009 17:25:41.0333 (UTC) FILETIME=[5C412850:01C9C36F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 21, 2009 10:51 PM, Greg KH wrote:
> On Wed, Apr 15, 2009 at 09:44:44PM -0400, H Hartley Sweeten wrote:
>> Fix sparse warning in drivers/usb/core/hub.c.
>> 
>> 	warning: symbol 'temp' shadows an earlier one
>
> Odd, I'm not seeing that when I run sparse on this file.  What
> version of sparse are you using?

Not sure about the sparse version.  I obtained the most recent version
with git on 15 Apr 2009.

I just rechecked the original file and I do see the warning.

  CHECK   drivers/usb/core/hub.c
drivers/usb/core/hub.c:472:3: warning: symbol 'temp' shadows an earlier
One drivers/usb/core/hub.c:460:20: originally declared here

This was found on a EP93xx ARM platform. It appears the sparse warning 
is caused by the raw_local_irq_save() macro in
arch/arm/include/asm/irqflags.h.

> Also, the patch is line-wrapped and you delete a lot of trailing
> spaces. Deleting trailing spaces is nice, but that's not what you
> said you were doing here in this patch, so I'm going to have to
> drop it.

Sorry about the line-wrapping. I'm still trying to work that out.

I noticed the trailing spaces getting fixed in the patch. I didn't
know I had to mention that in the patch description. Again sorry.

> thanks,
>
> greg k-h

Regards,
Hartley

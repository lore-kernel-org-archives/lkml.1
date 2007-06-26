Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbXFZOU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbXFZOU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbXFZOUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:20:16 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:22990 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbXFZOUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:20:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rqMi0PZLVSSQx1w1H5sJjYnK5Tnq+nE8ncvRAhmY0rNwAf59n4sm66zrfkcHJFI+JB8rLsjorUDeUt8iLv6/VSfWkK9RdeYZRaHuUWuFjLaW7XUQL5VxAf4YaL6iBSNJdFz9tnQR1Yf/ZvH7HG4wiH/C9q+JHLufQIVmNEXohSQ=
Message-ID: <20f65d530706260720w797861fuc4e10bbbe2a489d2@mail.gmail.com>
Date: Wed, 27 Jun 2007 02:20:12 +1200
From: "Keith Chew" <keith.chew@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: usb_fill_bulk_urb() broken for USB1.1?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

We have been using a Zydas based WIFI drivers under kernel 2.6.16.18
with great success. Recently, when we upgraded to 2.6.20.1 (also
tested on 2.6.21.5), we found that during initialisation, these calls
works with USB2.0 but stopped working on USB1.1:

usb_fill_bulk_urb();
usb_submit_urb();

The error code returned is -22 (-EINVAL). In 2.6.16.18, it works for
both USB2.0 and 1.1.

When we change to use usb_fill_int_urb(), it then works for USB1.1,
but takes up to 15 seconds (usually less than 5 seconds) for the
driver to initialise. Also, usb_fill_int_urb() does not work for
USB2.0 (kernel panic).

Can anyone point us to the right direction on how to get
usb_fill_bulk_urb() working on USB1.1? We need this as not all of the
deployed machines have USB2.0 enabled.

Regards
Keith

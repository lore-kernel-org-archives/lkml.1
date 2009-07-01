Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbZGARca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbZGARca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZGARcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:32:20 -0400
Received: from exprod6og103.obsmtp.com ([64.18.1.185]:44975 "HELO
	exprod6og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755355AbZGARcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:32:19 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: Problem with /proc/iomem on ARM
Date: Wed, 1 Jul 2009 13:32:19 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901A13822@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Problem with /proc/iomem on ARM
Thread-Index: Acn6ceJ1e1ANMaXmSxOIOJb7Dx7rYQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <kay.sievers@vrfy.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Jul 2009 17:32:20.0882 (UTC) FILETIME=[E351FF20:01C9FA71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kay,

I just noticed a problem with /proc/iomem on my ARM system
that I think was introduced by your patch:

commit 1d559e29138834bbcdf34ac072232bf543bfc4e0
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Tue Jan 6 10:44:43 2009 -0800

    arm: struct device - replace bus_id with dev_name(), dev_set_name()

    Cc: Russell King <rmk@arm.linux.org.uk>
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

On my ep93xx ARM system I have three pl010 uarts: "apb:uart1",
"apb:uart2", and "apb:uart3".  For /proc/iomem I used to see:

/ # cat proc/iomem
...
808c0000-808c0fff : apb:uart1
  808c0000-808c003f : uart-pl010
808d0000-808d0fff : apb:uart2
  808d0000-808d003f : uart-pl010
808e0000-808e0fff : apb:uart3
  808e0000-808e003f : uart-pl010
...

Now it shows up as:

/ # cat proc/iomem
...
808c0000-808c0fff : <BAD>
  808c0000-808c003f : uart-pl010
808d0000-808d0fff : <BAD>
  808d0000-808d003f : uart-pl010
808e0000-808e0fff : <BAD>
  808e0000-808e003f : uart-pl010
...

Is this a regression or is there something else going on?

This was seen with kernel 2.6.30.  I havn't looked at /proc/iomem for
a while so I'm not sure when this first started.

Regards,
Hartley

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764808AbXJOQIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764808AbXJOQIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763444AbXJOQIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:08:24 -0400
Received: from s1.mailresponder.info ([193.24.237.10]:3792 "EHLO
	s1.mailresponder.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763368AbXJOQIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:08:22 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2007 12:08:21 EDT
Subject: Inquiry data and emulated SG devices
From: Mathieu Fluhr <mfluhr@nero.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Nero AG
Date: Mon, 15 Oct 2007 18:02:11 +0200
Message-Id: <1192464131.3234.25.camel@de-c-l-110.nero-de.internal>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,


First of all, let me introduce myself a little bit. I am the responsable
for the development of the Nero Linux burning application. So I have
access to all the source code of the application.


Now let's go with the story: It seems that there is a slight problem in
the libata (and also the new pata_xxx) interfaces with the data returned
by the INQUIRY cmd since every S-ATA or IDE device is assumed to be a
SCSI dev.

Normally, the IDE devices (physical type) can be differentied with the
format field of the inquiry data, i.e. the last bytes (ANSI version) are
set to 0 -> This is done and works great with USB external devices for
example.


The thing is that with S-ATA/IDE devices when using the libata/pata
driver, the version field is (always?) set to 5, as any _real_ SCSI
device, and thus the physical device type cannot be checked anymore.

I cannot go so deep in details, but our burn engine is differentiating
IDE and read-good-old-SCSI devices and handles them sometimes in a
different way, so this differenciation is really important for us.

   -> How can I detect the real physical device type now?



Best Regards,
Mathieu


-- 
*********************************************************
Mathieu Fluhr
Linux Development Team Leader

E-mail: mfluhr@nero.com


NERO - BECAUSE TECHNOLOGY COUNTS
www.nero.com

*********************************************************
Nero AG
Im Stoeckmaedle 13-15
76307 Karlsbad
Germany

Vorstand/CEO: Richard Lesser
Aufsichtsratvorsitzender/chairman of the supervisory board: Jim Corbett

Amtsgericht Mannheim HRB 362519
*********************************************************
This e-mail may contain confidential and/or
privileged information. If you are not the intended
recipient (or have received this e-mail in error)
please notify the sender immediately and destroy
this e-mail. Any unauthorised copying, disclosure
or distribution of the material in this e-mail is
strictly forbidden.
********************************************************* 


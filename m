Return-Path: <linux-kernel-owner+w=401wt.eu-S936702AbXGUIDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936702AbXGUIDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936010AbXGUICe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:02:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:55408 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934427AbXGUICb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=sia1gb7NUN1gkzjzvWs9AOJJm1a7Yw/GjbXflka4V37rtYGZewQ9ibTtsZi4lMp/19hK86UhpITHmzyRFxLWOU3VtlZ4a5+6fJBKVhOkh0Z5Us3A0TA9T4nyfhNKAEAnC5BMnFhP5MPGSh8tHzhp0SEI2VsDwF3KklHrsOJhwpY=
Message-ID: <46A1BD31.4000804@googlemail.com>
Date: Sat, 21 Jul 2007 10:00:49 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       rdunlap@xenotime.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>	 <20070720155912.079c5a27.akpm@linux-foundation.org>	 <20070720231052.GA19752@suse.de>	 <a781481a0707201643l17ea92fajfbc256a7a16a802f@mail.gmail.com>	 <a781481a0707201703h6318fe65td4c5c6f57bb7eb24@mail.gmail.com>	 <6bffcb0e0707201728u6deeccd1j453ff89d0767dccc@mail.gmail.com>	 <20070721010257.GA9561@suse.de>	 <20070720183733.c53b511b.akpm@linux-foundation.org>	 <20070721014419.GA10761@suse.de>	 <a781481a0707202021r977ae5fg9655dd2881836f13@mail.gmail.com> <a781481a0707202057q23a0ea6by97ee9b40e9fc5a0b@mail.gmail.com>
In-Reply-To: <a781481a0707202057q23a0ea6by97ee9b40e9fc5a0b@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma pisze:
> On 7/21/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
>> Hopefully this bug should be 100% reproducible at boot time anyway.
>> Don't care much for XFS and unionfs, but hoping deselecting ATA from
>> the config doesn't change the variables much in this equation. ]
> 
> 
> Gargh! My system obviously cannot boot without libata. Guess it's
> time to go through git log and see how to fix that build breakage
> myself ...
> 
> Michal, how did you even manage to build / boot this kernel!

I commented origin.patch and mm.patch in series file, reverted xfs patches,
fixed libata build, deselected unionfs.

Here is a patch for libata

--- linux-work3-clean/drivers/ata/libata-core.c	2007-07-20 16:53:26.000000000 +0200
+++ linux-work3/drivers/ata/libata-core.c	2007-07-20 17:26:30.000000000 +0200
@@ -2036,7 +2036,7 @@ int ata_dev_configure(struct ata_device 
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
-	if (ata_device_blacklisted(dev) & ATA_HORKAGE_ALPM) {
+	if (ata_dev_blacklisted(dev) & ATA_HORKAGE_ALPM) {
 		dev->horkage |= ATA_HORKAGE_ALPM;
 
 		/* reset link pm_policy for this port to no pm */

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

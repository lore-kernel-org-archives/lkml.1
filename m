Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYBYTTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYBYTTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 14:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYBYTT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 14:19:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:3204 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbYBYTTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 14:19:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dRuBBepiNBqYXDY8Fth3YHu3qRnlRQFbUQ1f7zj88dhkVRWN+3y6YppUsm3il5TfdQXEnEWGRGALZ8g07x0kKAd8tLljYcnERqJ6Va2PVFdtLd3V2oxrFWsvfxJvZCEh8zAZROt/jasuzs/VCO6hxpYvRmHqu7b2t4Z+xSBiWx0=
Message-ID: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com>
Date: Mon, 25 Feb 2008 21:19:24 +0200
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org
Subject: new regression in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my T61p, 2.6.25-rc2 seems to get acpi events from keypresses
such as Fn-F4 and lid open/close, prints them in /var/log/acpid
and reacts accordingly (my acpi scripts suspend on lid close and Fn-F4).

This no longer happens in 2.6.25-rc3: I see nothing in /var/log/acpid
after power on:
[Mon Feb 25 20:47:28 2008] completed event "button/power PWRF 00000080 00000001"
[Mon Feb 25 20:48:44 2008] starting up
[Mon Feb 25 20:48:44 2008] 57 rules loaded
[Mon Feb 25 20:48:48 2008] client connected from 5927[0:0]
[Mon Feb 25 20:48:48 2008] 1 client rule loaded

and pressing buttons or closing lid produces no output in
/var/log/acpid and seems to have no effect.

git bisect pointed at commit 208c70a45624400fafd7511b96bc426bf01f8f5e :
ACPI: EC: Use proper handle for boot EC

If I do git revert 208c70a45624400fafd7511b96bc426bf01f8f5e on top
of 2.6.25-rc3, I start getting keyboard acpi events, again.


Thanks,
MST

PS: I see a different problem on resume, it seems to be unrelated to ACPI
and I will bisect and report separately.

PPS: Pls Cc me directly, I am not on the list.

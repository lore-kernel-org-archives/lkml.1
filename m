Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbYHTMHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbYHTMHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 08:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYHTMHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 08:07:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:51561 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbYHTMHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 08:07:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Richter <robert.richter@amd.com>
Subject: Re: powerpc/cell/oprofile: fix mutex locking for spu-oprofile
Date: Wed, 20 Aug 2008 14:05:31 +0200
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net, Paul Mackerras <paulus@samba.org>,
       cel <cel@linux.vnet.ibm.com>
References: <1217620879.15667.145.camel@carll-linux-desktop> <200808110925.08485.arnd@arndb.de> <20080820115750.GO13011@erda.amd.com>
In-Reply-To: <20080820115750.GO13011@erda.amd.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808201405.32101.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/7A2asSTTPM2HmwcA+PEy4TKoVPsCf5Jvuc/8
 wThQsil4wzFXGn/yVmqsX7T0ERAHE8nQaqdcO6u2n4oyDgHWQn
 qZeQPInSjzBphzAJvu3MQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 August 2008, Robert Richter wrote:
> I am fine with the changes with the exception of removing
> add_event_entry() from include/linux/oprofile.h. Though there is no
> usage of the function also in other architectures anymore, this change
> in the API should be discussed on the oprofile mailing list. Please
> separate the change in a different patch and submit it to the mailing
> list. If there are no objections then, this change can go upstream as
> well.

As an explanation, the removal of add_event_entry is the whole point
of this patch. add_event_entry must only be called with buffer_mutex
held, but buffer_mutex itself is not exported.
I'm pretty sure that no other user of add_event_entry exists, as it
was exported specifically for the SPU support and that never worked.
Any other (theoretical) code using it would be broken in the same way
and need a corresponding fix.

We can easily leave the declaration in place, but I'd recommend removing
it eventually. If you prefer to keep it, how about marking it as
__deprecated?

	Arnd <><

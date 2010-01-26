Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869Ab0AZSmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0AZSmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857Ab0AZSmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:42:46 -0500
Received: from cp-out1.libero.it ([212.52.84.101]:39916 "EHLO
	cp-out1.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab0AZSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:42:45 -0500
Message-ID: <30248841.411931264531362541.JavaMail.defaultUser@defaultHost>
Date: Tue, 26 Jan 2010 19:42:42 +0100 (CET)
From: "flinco@libero.it" <flinco@libero.it>
Reply-To: "flinco@libero.it" <flinco@libero.it>
To: <mad_soft@inbox.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: R: Re: R: [Bug #14886] Asus P2B-DS not detected as SMP moterboard
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arkadiusz Miskiewicz <arekm@maven.pl>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-SenderIP: 79.50.1.15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

I will try current git as soon as possible and I will post the results.

Many thanks and Best Regards,
Lorenzo Buzzi

>----Messaggio originale----
>Da: mad_soft@inbox.ru
>Data: 26/01/2010 16.53
>A: "Linux Kernel Mailing List"<linux-kernel@vger.kernel.org>
>Cc: "flinco@libero.it"<flinco@libero.it>, "Rafael J. Wysocki"<rjw@sisk.pl>, 
"Kernel Testers List"<kernel-testers@vger.kernel.org>, "Arkadiusz Miskiewicz"
<arekm@maven.pl>, "H. Peter Anvin"<hpa@zytor.com>, "Andrew Morton"<akpm@linux-
foundation.org>, "Feng Tang"<feng.tang@intel.com>, "Len Brown"<len.brown@intel.
com>
>Ogg: Re: R: [Bug #14886] Asus P2B-DS not detected as SMP moterboard
>
>On 20:40 Mon 11 Jan     , Rafael J. Wysocki wrote:
>> On Monday 11 January 2010, flinco@libero.it wrote:
>> > Tried 2.6.32.3. The issue is still present.
>> 
>> Thanks for the update.
>> 
>> Rafael
>
>(I have some troubles with registering on kernel bugzilla, so posting here,
>adding people from bug to CC: list)
>
>Hi!
>I'm also using P2B-DS and can confirm that starting with kernel 2.6.32
>SMP stopped working (and don't work still - tested with current git
>v2.6.33-rc5-238-g158c168) The issue seems to have something to do with the
>fact that ACPI is blacklisted on P2B-DS. I used to workaround this bug
>on newer kernels (>=2.6.32) by passing "acpi=force" in kernel arguments.
>Finally, yesterday I found some time to write simple automated bisection
>script and leaved it to run on machine overnight. Here's result:
>---------------------------------------------------------------------------
>e5b8fc6ac158f65598f58dba2c0d52ba3b412f52 is the first bad commit
>commit e5b8fc6ac158f65598f58dba2c0d52ba3b412f52
>Author: Len Brown <len.brown@intel.com>
>Date:   Tue Jul 7 23:22:58 2009 -0400
>
>    ACPI: check acpi_disabled in acpi_table_parse() and 
acpi_table_parse_entries()
>    
>    Allow consumers of the acpi_table_parse()/acpi_table_parse_entries() API
>    to gracefully handle the acpi_disabled=1 case via return value
>    rather than checking the global flag themselves.
>    
>    Signed-off-by: Feng Tang <feng.tang@intel.com>
>    Signed-off-by: Len Brown <len.brown@intel.com>
>---------------------------------------------------------------------------
>
>I re-checked this result and yes - reverting this commit on both 2.6.32 and
>current git (v2.6.33-rc5-238-g158c168) makes problem go away.
>
>-- 
>Best regards,
>Dmitry "MAD" Artamonow
>
>



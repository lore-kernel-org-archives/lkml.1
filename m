Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685Ab0AZQWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0AZQWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129Ab0AZQWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:22:01 -0500
Received: from fallback4.mail.ru ([94.100.176.42]:58009 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab0AZQWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:22:00 -0500
X-Greylist: delayed 1704 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 11:22:00 EST
Date: Tue, 26 Jan 2010 18:53:30 +0300
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "flinco@libero.it" <flinco@libero.it>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Arkadiusz Miskiewicz <arekm@maven.pl>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: R: [Bug #14886] Asus P2B-DS not detected as SMP moterboard
Message-ID: <20100126155330.GA4231@rainbow>
References: <5550914.425471263201351807.JavaMail.defaultUser@defaultHost>
 <201001112040.45514.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001112040.45514.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:40 Mon 11 Jan     , Rafael J. Wysocki wrote:
> On Monday 11 January 2010, flinco@libero.it wrote:
> > Tried 2.6.32.3. The issue is still present.
> 
> Thanks for the update.
> 
> Rafael

(I have some troubles with registering on kernel bugzilla, so posting here,
adding people from bug to CC: list)

Hi!
I'm also using P2B-DS and can confirm that starting with kernel 2.6.32
SMP stopped working (and don't work still - tested with current git
v2.6.33-rc5-238-g158c168) The issue seems to have something to do with the
fact that ACPI is blacklisted on P2B-DS. I used to workaround this bug
on newer kernels (>=2.6.32) by passing "acpi=force" in kernel arguments.
Finally, yesterday I found some time to write simple automated bisection
script and leaved it to run on machine overnight. Here's result:
---------------------------------------------------------------------------
e5b8fc6ac158f65598f58dba2c0d52ba3b412f52 is the first bad commit
commit e5b8fc6ac158f65598f58dba2c0d52ba3b412f52
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jul 7 23:22:58 2009 -0400

    ACPI: check acpi_disabled in acpi_table_parse() and acpi_table_parse_entries()
    
    Allow consumers of the acpi_table_parse()/acpi_table_parse_entries() API
    to gracefully handle the acpi_disabled=1 case via return value
    rather than checking the global flag themselves.
    
    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
---------------------------------------------------------------------------

I re-checked this result and yes - reverting this commit on both 2.6.32 and
current git (v2.6.33-rc5-238-g158c168) makes problem go away.

-- 
Best regards,
Dmitry "MAD" Artamonow


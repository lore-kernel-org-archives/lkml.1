Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZGDEOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZGDEOT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 00:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbZGDEOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 00:14:07 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:39222 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZGDEOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 00:14:06 -0400
X-IronPort-AV: E=Sophos;i="4.42,345,1243828800"; 
   d="scan'208";a="3420907"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
Subject: Boot Consoles question...
Date: Sat, 4 Jul 2009 00:17:26 -0400
User-Agent: KMail/1.9.5
CC: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907040017.26921.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 04 Jul 2009 04:14:08.0150 (UTC) FILETIME=[E0444B60:01C9FC5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quick question...

In register_console()

        if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == 
CON_CONSDEV)) {
		[[snip]]
                newcon->flags &= ~CON_PRINTBUFFER;
        }

So - when we are switching over from a boot console to a "real" console 
- we don't back up the console, and print everything out.

This means that the boot console is on a different device than that
"real" console - you don't actually see the full boot message (from 
log_start) on the "real" console.

Is this what is intended (that the boot message gets split into 2 -
1/3 going into the bootconsole - and the remaining to to the real 
console?)

I can understand this when both (boot and real) are the same device (serial) 
or vga, but where they are not - it is a little confusing to the user - isn't 
it?

Thanks
-Robin

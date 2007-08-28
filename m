Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbXH1XnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbXH1XnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 19:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXH1XnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 19:43:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46186 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbXH1XnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 19:43:06 -0400
Date: Tue, 28 Aug 2007 16:42:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.23-rc4: BAD regression
In-Reply-To: <200708290129.57243.daniel.ritz-ml@swissonline.ch>
Message-ID: <alpine.LFD.0.999.0708281636380.25853@woody.linux-foundation.org>
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Len? Should we just revert it?

That commit has been very painful. First it lost all registration of the 
query methods, and now this.

Daniel - can we please have a before/after dmesg on your machine, 
preferably with ACPI debugging enabled? And for ACPI stuff, it usually 
does help to fill in a bugzilla entry, since the ACPI people actually do 
track things there...

		Linus

On Wed, 29 Aug 2007, Daniel Ritz wrote:
>
> tried that one on my old toshiba tecra 8000 laptop, almost killing it.
> the fan doesn't work any more...type 'make' and see the box dying.
> luckily my CPU doesn't commit suicide...bisected it to that one:
> 
> cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b is first bad commit
> commit cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
> Author: Alexey Starikovskiy <astarikovskiy@suse.de>
> Date:   Fri Aug 3 17:52:48 2007 -0400
> 
>     ACPI: EC: If ECDT is not found, look up EC in DSDT.
> 
>     Some ASUS laptops access EC space from device _INI methods, but do not
>     provide ECDT for early EC setup. In order to make them function properly,
>     there is a need to find EC is DSDT before any _INI is called.
> 
>     Similar functionality was turned on by acpi_fake_ecdt=1 command line
>     before. Now it is on all the time.
> 
>     http://bugzilla.kernel.org/show_bug.cgi?id=8598
> 
>     Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 

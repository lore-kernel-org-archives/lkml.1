Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbYEOToy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbYEOToy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYEOToq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:44:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49234 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198AbYEOTop convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:44:45 -0400
From: Alok Kataria <akataria@vmware.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: "devzero@web.de" <devzero@web.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Date: Thu, 15 May 2008 12:44:40 -0700
Subject: RE: Kernel hangs in SMP + VMware environment.
Thread-Topic: Kernel hangs in SMP + VMware environment.
Thread-Index: Aci2Uphznj/UMB3nSQ2ok+QDzNYWjAAcHlzK
Message-ID: <D3C12B2AD838B44DA9D6B2CA334246D00D8F38DA60@PA-EXMBX04.vmware.com>
References: <1210789834.8798.20.camel@promb-2n-dhcp368.eng.vmware.com>,<200805150611.m4F6Bv4J046219@www262.sakura.ne.jp>
In-Reply-To: <200805150611.m4F6Bv4J046219@www262.sakura.ne.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tetsuo,

Thanks for testing.

Actually it would be better to use clocksource=acpi_pm on kernels which don't have this patch, as ACPI_PM comes with many more featuers like hrtimers, nohz, etc.

On the other hand for kernels which have this patch attached,  it would be best to use TSC, for performance.

HTH,
Alok.

________________________________________
From: Tetsuo Handa [penguin-kernel@i-love.sakura.ne.jp]
Sent: Wednesday, May 14, 2008 11:11 PM
To: Alok Kataria
Cc: devzero@web.de; linux-kernel@vger.kernel.org; Daniel Hecht
Subject: Re: Kernel hangs in SMP + VMware environment.

Hello.

Alok Kataria wrote:
> Can you try the patch attached with this mail, I made this on top of
> 2.6.24.7 but should fit on any other 2.6.24 based distro kernel.

I tried 2.6.24.5-85.fc8 with your patch, and I can no longer reproduce
this problem. I think the problem has been solved.


Also, workaround till your patch is applied to distro kernels seems to be
to add "clocksource=jiffies" or something to avoid using tsc as clocksource.
Fedora 9's 2.6.25-14.fc9 also hangs since the default clocksource is tsc, but
with "clocksource=jiffies" added, I encounter no hangs so far.



>From today, I can compile kernels using 2 CPUs.
Thank you very much.

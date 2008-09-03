Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYICSqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYICSqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbYICSpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:45:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:55852 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687AbYICSpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:45:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="376377176"
Date: Wed, 3 Sep 2008 11:45:52 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [patch 1/2] x2apic: fix reserved APIC register accesses in print_local_APIC()
Message-ID: <20080903184552.GE14481@linux-os.sc.intel.com>
References: <20080902234759.554038000@linux-os.sc.intel.com> <Pine.LNX.4.55.0809030625520.23174@cliff.in.clinika.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0809030625520.23174@cliff.in.clinika.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 10:28:54PM -0700, Maciej W. Rozycki wrote:
> On Tue, 2 Sep 2008, Suresh Siddha wrote:
> 
> > APIC_RRR is a reserved register for integrated APIC's.
> 
>  NAK this change -- the Remote Read register is officially supported up to
> the Pentium integrated APIC and to the best of my knowledge it works with
> the P6 APIC as well.  Any APIC using the serial inter-APIC bus should
> support it.

from SDV Vol 3a Section 17.27.1

  The remote read delivery mode provided in the 82489DX and local APIC for
  Pentium processors is not supported in the local APIC in the Pentium 4, Intel
  Xeon, and P6 family processors.

It looks like it is not supported (officially atleast) even in APIC bus
architectures. Only the Pentium integrated APIC seems to be the exception.

I have to probably use maxlvt check, to selectively enable this debug output
for Pentium and !APIC_INTEGRATED check for 82489DX.

thanks,
suresh

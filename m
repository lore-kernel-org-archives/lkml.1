Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYFPAmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYFPAmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 20:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYFPAlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 20:41:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:5422 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbYFPAly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 20:41:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,649,1204531200"; 
   d="scan'208";a="577887479"
Date: Sun, 15 Jun 2008 17:41:53 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Message-ID: <20080616004153.GA7788@linux-os.sc.intel.com>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <200806142359.36613.elendil@planet.nl> <8B23168BCBB43B49A4C8EAB32D4B62F1061F3A82@orsmsx505.amr.corp.intel.com> <200806160102.11717.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806160102.11717.elendil@planet.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 04:02:10PM -0700, Frans Pop wrote:
> I've done 4 successive boots with the boot parameters as shown below.
> Each boot was basically: set correct parameters in grub -> login to KDE
>                          -> reboot and check for artifacts.
> 
> 1) (none)                      --> clean
> 2) vga=791                     --> artifacts
> 3) vga=791 nopat               --> clean
> 4) vga=791 video=vesafb:mtrr:3 --> artifacts
> 
> So the mtrr option did not help (if I passed it correctly; the double ":"
> is somewhat non-intuitive). The kernel log also does not show any
> difference I can see in the last boot, but I don't know if the mtrr option
> is supposed to show up in any way.

If the initlevel is '3', then the mtrr option will show up in /proc/mtrr
otheriwse not. In init level '5', X server will add the mtrr (irrespective
of boot option, if it's not already there) and will remove it when the X process
completes its execution.

Can you also please try if "mtrr:1" makes any difference. This will setup the
mapping as UC during boot. Apart from PAT WC mapping(which we shouldn't be using
in your current setup), UC MTRR should override all the other PAT mappings and
should be consistent across X and VT console mappings. As such, if the
problem is because of improper aliasing, then with this UC MTRR,
my understanding is that we shouldn't see any artifacts with the "mtrr:1".

with this mtrr:1, we should now see a UC mtrr setting in /proc/mtrr.

thanks,
suresh

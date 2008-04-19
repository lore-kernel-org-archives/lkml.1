Return-Path: <linux-kernel-owner+w=401wt.eu-S1762220AbYDSPVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762220AbYDSPVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbYDSPU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:20:57 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:56744 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbYDSPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:20:56 -0400
Date: Sat, 19 Apr 2008 08:20:49 -0700 (PDT)
From: Dave Olson <dave.olson@qlogic.com>
To: Roland Dreier <rdreier@cisco.com>
cc: Ingo Molnar <mingo@elte.hu>, Ralph Campbell <ralph.campbell@qlogic.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull infiniband.git
In-Reply-To: <adaod86aq9j.fsf@cisco.com>
Message-ID: <alpine.LFD.1.00.0804190817280.21302@topaz.pathscale.com>
References: <adaskxkh6s2.fsf@cisco.com> <20080419081614.GA2437@elte.hu> <adaod86aq9j.fsf@cisco.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 19 Apr 2008 15:20:56.0217 (UTC) FILETIME=[F6C31890:01C8A230]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2008, Roland Dreier wrote:
|  >  drivers/built-in.o: In function `ipath_init_one':
|  >  ipath_driver.c:(.devinit.text+0x1e5bc): undefined reference to `ipath_init_iba7220_funcs'

Yes, that issue should be fixed.  Our preference was to not build
if it wouldn't work.  We'd have to add the conditional check at
the function setup routines.


| I also removed the dependency on HT_IRQ || PCI_MSI in the Kconfig, since
| the iba7220 support should work without it.  I know we discussed this
| before, but looking closer at the code, the dependency seems pointless
| to me, since it's still possible to build a driver that doesn't work if
| a particular system needs, say HT_IRQ, and the user selects PCI_MSI.
| And since iba7220 doesn't need either, we might as well let people build
| that.
| 
| If this is OK with everyone, I will merge this with a proper changelog.

At this point, I guess I'd agree.  We've added checks for "no interrupt"
after the driver is loaded, so I guess that covers the issue well
enough.

Dave Olson
dave.olson@qlogic.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbYDSQMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbYDSQMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYDSQMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:12:09 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:41190 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbYDSQMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:12:07 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Dave Olson <dave.olson@qlogic.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ralph Campbell <ralph.campbell@qlogic.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull infiniband.git
References: <adaskxkh6s2.fsf@cisco.com> <20080419081614.GA2437@elte.hu>
	<adaod86aq9j.fsf@cisco.com>
	<alpine.LFD.1.00.0804190817280.21302@topaz.pathscale.com>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 19 Apr 2008 09:12:06 -0700
In-Reply-To: <alpine.LFD.1.00.0804190817280.21302@topaz.pathscale.com> (Dave
	Olson's message of "Sat, 19 Apr 2008 08:20:49 -0700 (PDT)")
Message-ID: <adafxthbz8p.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Apr 2008 16:12:06.0364 (UTC) FILETIME=[1CB659C0:01C8A238]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > |  >  drivers/built-in.o: In function `ipath_init_one':
 > |  >  ipath_driver.c:(.devinit.text+0x1e5bc): undefined reference to `ipath_init_iba7220_funcs'
 > 
 > Yes, that issue should be fixed.  Our preference was to not build
 > if it wouldn't work.  We'd have to add the conditional check at
 > the function setup routines.

Not sure I really follow this response... ipath_driver.c has

	case PCI_DEVICE_ID_INFINIPATH_7220:
#ifndef CONFIG_PCI_MSI
		ipath_dbg("CONFIG_PCI_MSI is not enabled, "
			  "using IntX for unit %u\n", dd->ipath_unit);
#endif
		ipath_init_iba7220_funcs(dd);
		break;

so clearly ipath_init_iba7220_funcs() was intended to be built and used
even if CONFIG_PCI_MSI was not defined.  From the code it looks like all
should work fine if PCI_MSI is not set, so I don't know what you mean
about conditional checks.

(BTW since I'm looking at this code, "IntX" should probably be
capitalized as "INTx" to match what the PCI specs say)

 - R.

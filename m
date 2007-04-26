Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbXDZU5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbXDZU5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbXDZU5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:57:36 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:60154 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbXDZU5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:57:36 -0400
Message-ID: <46311231.3090903@freescale.com>
Date: Thu, 26 Apr 2007 15:57:21 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Kumar Gala <galak@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: 2.6.21-rc7-mm2
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>	<46309142.2010907@googlemail.com> <20070426133720.25085207.akpm@linux-foundation.org>
In-Reply-To: <20070426133720.25085207.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>> drivers/net/Kconfig:2327:warning: 'select' used by config symbol 
>> 'UCC_GETH' refer to undefined symbol 'UCC_FAST'
> 
> Yes, we get so many of those that I tend to ignore them, assuming that
> someone will pick it up and fix it.

Is this being compiled on a non-ppc/powerpc platform?  That might explain it.  UCC_GETH is 
defined in drivers/net/Kconfig, but UCC_FAST is defined in 
arch/powerpc/sysdev/qe_lib/Kconfig.  So I supposed if you don't compile for ARCH=powerpc, 
then arch/powerpc/sysdev/qe_lib/Kconfig is never loaded?

If that's the case, then we're always going to have this problem with platform-dependent 
drivers in the /drivers/ directory.  The ucc_geth driver depends on the "QE library", 
which is present only on some PowerPC processors, so we put the config options for the QE 
in arch/powerpc.  But since ucc_geth is a standard Ethernet driver, it exists in drivers/net.

-- 
Timur Tabi
Linux Kernel Developer @ Freescale

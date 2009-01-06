Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZAFQ3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZAFQ3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZAFQ3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:29:34 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:53749 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZAFQ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:29:32 -0500
Message-ID: <496386DB.8090606@oracle.com>
Date: Tue, 06 Jan 2009 08:29:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Korolev Alexey <akorolev@infradead.org>,
       Vasiliy Leonenko <vasiliy.leonenko@gmail.com>
Subject: Re: linux-next: Tree for January 6 (MTD)
References: <20090106182311.525e4b14.sfr@canb.auug.org.au>
In-Reply-To: <20090106182311.525e4b14.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.496386DF.0120:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> This tree will not build a powerpc ppc4xx_defconfig due to a kvm problem.
> 
> Changes since 20090105:
> 
> New tree:
> 	squashfs
> 
> Undropped tree:
> 	usb
> 	staging
> 
> Dropped trees (temporarily):
> 	rr (build problem)
> 	semaphore-removal (due to unfixed conflicts against Linus' tree)
> 	cpu_alloc (build problem)
> 	audit (difficult conflicts)
> 
> 
> The mtd tree lost 3 conflicts.

drivers/built-in.o: In function `lpddr_probe':
(.text+0x95ddc): undefined reference to `lpddr_cmdset'

with
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_QINFO_PROBE=y

There appears to be too little control/coordination between those
two kconfig symbols.  Surely one of them (MTD_QINFO_PROBE) should
depend on the other (MTD_LPDDR).  And why even build 2 modules
when MTD_QINFO_PROBE is enabled?  Why not combine the code into
one module?


-- 
~Randy

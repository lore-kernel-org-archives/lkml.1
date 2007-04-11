Return-Path: <linux-kernel-owner+w=401wt.eu-S1161222AbXDKGfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161222AbXDKGfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 02:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161223AbXDKGfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 02:35:09 -0400
Received: from koto.vergenet.net ([210.128.90.7]:33495 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161222AbXDKGfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 02:35:07 -0400
Date: Wed, 11 Apr 2007 15:33:51 +0900
From: Simon Horman <horms@verge.net.au>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       benh@kernel.crashing.org, davem@davemloft.net, ebiederm@xmission.com,
       heiko.carstens@de.ibm.com, ink@jurassic.park.msu.ru, jdike@addtoit.com,
       paulus@samba.org, rth@twiddle.net, schwidefsky@de.ibm.com,
       takata@linux-m32r.org, tony.luck@intel.com, vgoyal@in.ibm.com
Subject: Re: [PATCH 0/4] hard_smp_processor_id overhaul (v.2)
Message-ID: <20070411063349.GA8401@verge.net.au>
References: <1175676667.26920.128.camel@sebastian.intellilink.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1175676667.26920.128.camel@sebastian.intellilink.co.jp>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 05:51:07PM +0900, Fernando Luis Vázquez Cao wrote:
> This new version (v.2) fixes generic arch i386 up build, has (hopefully)
> clearer explanations, and does not break git bisect searches.
> ---
> With the advent of kdump, the assumption that the boot CPU when running
> an UP kernel is always the CPU with a particular hardware ID (often 0)
> (usually referred to as BSP on some architectures) is not valid anymore.
> The reason being that the dump capture kernel boots on the crashed CPU
> (the CPU that invoked crash_kexec), which may be or may not be that
> particular CPU.
> 
> As a consequence, the hardcoding of hard_smp_processor_id() to 0 on UP
> systems (see "linux/smp.h") is not correct.
> 
> This patch-set does the following:
> 
> 1- Remove hardcoding of hard_smp_processor_id on UP systems (patch 1).
> 
> 2- Move definition of hard_smp_processor_id for the UP case to
> architecture specific code ("asm/smp.h") where it belongs, so that each
> architecture can provide its own implementation (patch 1).
> 
> 3- Ask the hardware when possible to obtain the hardware processor id on
> i386 (patch 2), x86_64 (patch 3), and ia64 (patch 4), independently of
> whether CONFIG_SMP is set or not.
> 
> I guess that something similar could be done for the rest of the
> architectures, but since I am not an expert in all of them I am just
> moving the definition of hard_smp_processor_id to "asm/smp.h" for those.
> Of course, help from the respective maintainers to fill this gap would
> be greatly appreciated.
> 
> The patches have been tested on i386, x86_64, and ia64.

Sorry for the delay in getting back to you, I've been on the road.

All these patches seem fine to me.

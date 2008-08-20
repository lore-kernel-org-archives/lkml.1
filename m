Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYHTMkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYHTMkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 08:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYHTMkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 08:40:22 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:63605 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYHTMkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 08:40:20 -0400
X-BigFish: VPS-34(zz1432R98dR936eQ62a3L1805Mzz10d3izzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5WGIS-02-31X-01
Date: Wed, 20 Aug 2008 14:39:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net, Paul Mackerras <paulus@samba.org>,
       cel <cel@linux.vnet.ibm.com>
Subject: Re: powerpc/cell/oprofile: fix mutex locking for spu-oprofile
Message-ID: <20080820123944.GQ13011@erda.amd.com>
References: <1217620879.15667.145.camel@carll-linux-desktop> <18591.30474.127939.243247@cargo.ozlabs.ibm.com> <200808110918.57293.arnd@arndb.de> <200808110925.08485.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <200808110925.08485.arnd@arndb.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2008 12:40:05.0884 (UTC) FILETIME=[DF8663C0:01C902C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.08.08 09:25:07, Arnd Bergmann wrote:
> From: Carl Love <cel@us.ibm.com>
> 
> The issue is the SPU code is not holding the kernel mutex lock while
> adding samples to the kernel buffer.
> 
> This patch creates per SPU buffers to hold the data.  Data
> is added to the buffers from in interrupt context.  The data
> is periodically pushed to the kernel buffer via a new Oprofile
> function oprofile_put_buff(). The oprofile_put_buff() function
> is called via a work queue enabling the funtion to acquire the
> mutex lock.
> 
> The existing user controls for adjusting the per CPU buffer
> size is used to control the size of the per SPU buffers.
> Similarly, overflows of the SPU buffers are reported by
> incrementing the per CPU buffer stats.  This eliminates the
> need to have architecture specific controls for the per SPU
> buffers which is not acceptable to the OProfile user tool
> maintainer.
> 
> The export of the oprofile add_event_entry() is removed as it
> is no longer needed given this patch.
> 
> Note, this patch has not addressed the issue of indexing arrays
> by the spu number.  This still needs to be fixed as the spu
> numbering is not guarenteed to be 0 to max_num_spus-1.
> 
> Signed-off-by: Carl Love <carll@us.ibm.com>
> Signed-off-by: Maynard Johnson <maynardj@us.ibm.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Robert Richter <robert.richter@amd.com>

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


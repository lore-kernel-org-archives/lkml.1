Return-Path: <linux-kernel-owner+w=401wt.eu-S1762990AbZLPWtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762990AbZLPWtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759347AbZLPWtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:49:17 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:38996 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761297AbZLPWtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:49:14 -0500
Date: Thu, 17 Dec 2009 09:49:12 +1100
From: Simon Horman <horms@verge.net.au>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       kexec@lists.infradead.org
Subject: Re: kexec reboot broken with ioatdma?
Message-ID: <20091216224912.GC16219@verge.net.au>
References: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 01:32:11PM -0800, Roland Dreier wrote:
> I have a system with IOAT hardware, and rebooting with kexec fails with
> the latest 2.6.32-git kernel.  I haven't really tried earlier kernels,
> but I suspect the issue comes from the ioatdma driver being autoloaded now.
> 
> The reboot gets stuck at:
> 
>   ioatdma 0000:00:16.0: Self-test copy timed out, disabling
>   ioatdma 0000:00:16.0: Freeing 2 in use descriptors!
>   ioatdma 0000:00:16.0: Intel(R) I/OAT DMA Engine init failed
> 
> so presumably the IOAT hardware is left in a bad state that the ioatdma
> driver in the kexec'ed new kernel can't handle.
> 
> I notice that long ago, there was a commit 428ed602 ("I/OAT: fix I/OAT
> for kexec") that added a shutdown method to clean things up so kexec
> worked, and then more recently there was 4fac7fa5 ("ioat: do not perform
> removal actions at shutdown") that got rid of the shutdown hook.
> 
> I'm not sure what the correct fix is here: fix the shutdown order so
> everyone drops all references to IOAT stuff before IOAT is shutdown, or
> add some code to the ioatdma driver so it resets the hardware on startup
> so the new kernel can deal with an unspecified state.

Hi Roland,

from a kexec point of view I believe that the preferred option is the
former - shutdown the device so it can be initialised using standard paths
in the second kernel.


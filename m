Return-Path: <linux-kernel-owner+w=401wt.eu-S1763342AbZLPXLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763342AbZLPXLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762813AbZLPXLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:11:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:59047 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761569AbZLPXLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:11:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,408,1257148800"; 
   d="scan'208";a="476848542"
Message-ID: <4B296930.9020704@intel.com>
Date: Wed, 16 Dec 2009 16:11:44 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Simon Horman <horms@verge.net.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: kexec reboot broken with ioatdma?
References: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>	<20091216224912.GC16219@verge.net.au> <aday6l27c7w.fsf@roland-alpha.cisco.com>
In-Reply-To: <aday6l27c7w.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > from a kexec point of view I believe that the preferred option is the
>  > former - shutdown the device so it can be initialised using standard paths
>  > in the second kernel.
> 
> OK... however I'm not suggesting a separate kexec initialization path,
> simply adding a reset of the device in the standard initialization.
> This would be fairly normal for other types of device; for example, the
> BIOS may have left a NIC in an undefined state due to network boot.  Of
> course BIOS is unlikely to use an IOAT DMA engine but the principle of
> limiting assumptions about platform state still stands I think.

I agree that is more robust if the init path copes with hardware 
arriving in an unknown state.  I'll look into adding a channel reset in 
the init path (something that should probably have been there since the 
beginning).

> From a quick look, it seems tricky to get a clean shutdown of IOAT stuff
> since there doesn't seem to be a clean ordering that makes sure the
> ioatdma stuff is shutdown after everything using it.

The engines may be in use by multiple subsytems (net, raid) so 
coordinating shutdown ordering would indeed be a pain.

--
Dan


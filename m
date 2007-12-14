Return-Path: <linux-kernel-owner+w=401wt.eu-S1763359AbXLNJBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763359AbXLNJBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbXLNJBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:01:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:48571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506AbXLNJBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:01:01 -0500
Message-ID: <47624649.3040209@suse.de>
Date: Fri, 14 Dec 2007 10:00:57 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	 <47462F3C.3040700@googlemail.com>	 <20071122201250.f957e280.akpm@linux-foundation.org>	 <47466B5D.90607@googlemail.com>	 <20071126221509.8f437b61.akpm@linux-foundation.org> <1197390783.3812.19.camel@localhost.localdomain>
In-Reply-To: <1197390783.3812.19.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Mon, 2007-11-26 at 22:15 -0800, Andrew Morton wrote:
>> OK, thanks.  I'll assume that James and Hannes have this in hand (or will
>> have, by mid-week) and I won't do anything here.
> 
> Just to confirm what I think I'm going to be doing:  rebasing the
> scsi-misc tree to remove this commit:
> 
> commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0
> Author: Hannes Reinecke <hare@suse.de>
> Date:   Tue Nov 6 09:23:40 2007 +0100
> 
>     [SCSI] Do not requeue requests if REQ_FAILFAST is set
> 
> And its allied fix ups:
> 
> commit 983289045faa96fba8841d3c51b98bb8623d9504
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Sat Nov 24 19:47:25 2007 +0200
> 
>     [SCSI] fix up REQ_FASTFAIL not to fail when state is QUIESCE
> 
> commit 9dd15a13b332e9f5c8ee752b1ccd9b84cb5bdf17
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Sat Nov 24 19:55:53 2007 +0200
> 
>     [SCSI] fix domain validation to work again
> 
> James
> 
> 
Or just apply my latest patch (cf Undo __scsi_kill_request).
The main point is that we shouldn't retry requests
with FAILFAST set when the queue is blocked. AFAICS
only FC and iSCSI transports set the queue to blocked,
and use this to indicate a loss of connection. So any
retry with queue blocked is futile.

Cheers,

Hannes

-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

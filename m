Return-Path: <linux-kernel-owner+w=401wt.eu-S1761217AbXEVA0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbXEVA0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbXEVA01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:26:27 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4789 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbXEVA00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:26:26 -0400
X-Server-Uuid: 6B5CFB92-F616-4477-B110-55F967A57302
Subject: Re: intermittant petabyte usage reported with broadcom nic
From: "Michael Chan" <mchan@broadcom.com>
To: "CaT" <cat@zip.com.au>, jd@disjunkt.com
cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "netdev" <netdev@vger.kernel.org>
In-Reply-To: <1176596401.5847.7.camel@dell>
References: <20070402014319.GA8345@zip.com.au>
 <20070402001300.3b66007d.akpm@linux-foundation.org>
 <20070402074108.GB8345@zip.com.au> <1176596401.5847.7.camel@dell>
Date: Mon, 21 May 2007 18:15:04 -0700
Message-ID: <1179796504.1661.152.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6A4CE72F37032352743-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007 11:43:19 +1000 CaT <cat@zip.com.au> wrote:
>  
> I take minute by minute snapshots of network traffic by sampling
> /proc/net/dev and most of the time everything works fine. Occasionally
> though I get petabyte byte traffic and corresponding packet traffic.

We were able to reproduce the problem and confirmed that it was a DMA
problem of the statistics block.  About once an hour on average, wrong
counter values will be DMA'ed to host memory.  Luckily, the DMA write
stays within the intended address range so it will not corrupt other
parts of memory.  Other types of DMA including traffic and buffer
descriptors are not affected.

If you happen to be reading /proc/net/dev within a second after the DMA
corruption, you'll see bogus counters.  One second later and until the
next bad DMA, the counters will be normal again.

We are considering ways to workaround the problem.  Thanks.


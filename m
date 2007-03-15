Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbXCORrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbXCORrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 13:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932114AbXCORrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 13:47:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:33629 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227AbXCORrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 13:47:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,289,1170662400"; 
   d="scan'208"; a="210250540:sNHT16925230"
Date: Thu, 15 Mar 2007 10:46:54 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: Re: RSDL v0.30 cpu scheduler for mainline kernels
Message-ID: <20070315174654.GB12447@linux-os.sc.intel.com>
References: <200703121058.11966.kernel@kolivas.org> <20070315023102.GL30596@linux-os.sc.intel.com> <200703151705.13761.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703151705.13761.kernel@kolivas.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 05:05:13PM +1100, Con Kolivas wrote:
> On Thursday 15 March 2007 13:31, Siddha, Suresh B wrote:
> > Just to see the % increase in number of context switches, I ran 8 infinite
> > loops (simple while(1); 's) and with 2.6.21-rc3 I see ~70 context switches
> > every second, whereas with RSDL I see ~530 context switches.
> 
> Thanks. If it's just that then scaling rr interval with cpus somewhat would
> help. If you could, the following patch just to test might confirm that.
> -#define RR_INTERVAL		((6 * HZ / 1001) + 1)
> +#define RR_INTERVAL		((12 * HZ / 1001) + 1)

Context switches now are ~370 per second. Still much above the regular ~70
we see in the mainline.

why do you say the rr_interval needs to be scaled with cpus? The basic point
in RSDL is, if we have more than one same priority task on a single logic
cpu, context switch happens every RR_INTERVAL (6 or 12 msec) whereas in
mainline it happens every 100 msec.

We need to minimize these context switches.

thanks,
suresh

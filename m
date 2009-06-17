Return-Path: <linux-kernel-owner+w=401wt.eu-S932993AbZFQFIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993AbZFQFIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 01:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932927AbZFQFIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 01:08:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:11159 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932926AbZFQFIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 01:08:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,234,1243839600"; 
   d="scan'208";a="467093437"
Subject: Re: [PATCH] x86: efi/e820 table merge fix
From: Huang Ying <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cliff Wickman <cpw@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "yinghai@kernel.org" <yinghai@kernel.org>
In-Reply-To: <4A386B14.8030702@zytor.com>
References: <E1MGgRQ-0002pu-6Z@eag09.americas.sgi.com>
	 <1245201005.11965.4.camel@yhuang-dev.sh.intel.com>
	 <4A384914.1090900@zytor.com>
	 <1245203099.11965.7.camel@yhuang-dev.sh.intel.com>
	 <4A386B14.8030702@zytor.com>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 13:08:22 +0800
Message-Id: <1245215302.11965.19.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 12:03 +0800, H. Peter Anvin wrote:
> Huang Ying wrote:
> >>> Why does BIOS mark memory region without EFI_MEMORY_WB as these types?
> >>> Any example?
> >>>
> >> Probably not, but if it does, it's broken, and the memory should be
> >> ignored. The original code had the EFI_MEMORY_WB check already, so it
> >> seems prudent to keep it.
> > 
> > Maybe we need a real life example for that "fix". And attribute that to
> > the vendor in comments.
> > 
> > Best Regards,
> > Huang Ying
> 
> I think you're reading the patch backwards.
> 
> Before the patch, the EFI code didn't look at the type *AT ALL*, it only
> looked at the EFI_MEMORY_WB attribute.  This broke for SGI when they
> were -- correctly -- reserving real memory (and hence still
> EFI_MEMORY_WB) with the type set to EFI_RESERVED_TYPE.  This is correct
> behavior, but the old code saw that it was EFI_MEMORY_WB and therefore
> considered it usable RAM.  This is obviously broken.
> 
> Now why, you're asking, do we still look at md->attribute at all?
> That's where caution dictates that it is prudent to diverge from the
> previous behavior, but it is not *this* patch that should be the source
> of that question, but from the author of the existing code, which
> appears to be Paul Jackson of SGI.  Unfortunately, his email now bounces
> and noone has that information.

Yes. You are right. Thank you for your patient.

> If you think about it, though, we don't want to consider it as usable
> RAM if it isn't EFI_MEMORY_WB, and it would in fact be a bug (or
> workaround for a broken system) to ignore it.  In fact, we go through
> great pains elsewhere in the kernel to remove memory which isn't WB from
> the usable pool.

Because it appears that checking EFI_MEMORY_WB is not necessary, maybe
it is necessary to add some comments about why it is checked to prevent
it to be deleted later.

Best Regards,
Huang Ying



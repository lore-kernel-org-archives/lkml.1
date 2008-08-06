Return-Path: <linux-kernel-owner+w=401wt.eu-S1763378AbYHFLH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763378AbYHFLH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 07:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756732AbYHFLHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 07:07:14 -0400
Received: from mga10.intel.com ([192.55.52.92]:5885 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754513AbYHFLHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 07:07:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,314,1215414000"; 
   d="scan'208";a="604447614"
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API -V3.
From: Austin Zhang <austin_zhang@linux.intel.com>
To: Pavel Machek <pavel@suse.cz>
Cc: herbert@gondor.apana.org.au, bunk@kernel.org, dwmw2@infradead.org,
       davem@davemloft.net, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <20080806094226.GA23685@atrey.karlin.mff.cuni.cz>
References: <1218000211.4231.23.camel@localhost.localdomain>
	 <20080806094226.GA23685@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 06 Aug 2008 07:05:27 -0400
Message-Id: <1218020727.29030.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paval,

Thanks for your comments. 

On Wed, 2008-08-06 at 11:42 +0200, Pavel Machek wrote:
> Copyright / GPL?
Yes, as : ﻿+MODULE_LICENSE("GPL");

> > +#ifdef CONFIG_X86_64
> > +#define REX_PRE "0x48, "
> > +#define SCALE_F 8
> > +#else
> > +#define REX_PRE
> > +#define SCALE_F 4
> > +#endif
> 
> Ouch...
Any good suggestion will be appreciated. 

> > +static u32 crc32c_intel_le_hw_byte(u32 crc, unsigned char const *data, size_t length)
> > +{
> > +	while (length--) {
> > +		__asm__ __volatile__(
> 
> Are all the underscores neccessary?
What's big impact if keep those underscores? Just keep ANSI C  style.


> 
> > +		return -1;
> 
> That's supposed to be errno, right?
Are you suggest "ENODEV"? It's a feature from the device but the device is exact here. 
And for the crc32c algorithm, there would be possible that several
algorithms registered themselves in crypto and user will don't care
which implementation will server him even the hardware accelerated
implementation don't exist in this processor. 





Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbZD0Pl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbZD0Pl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZD0Pls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:41:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46392 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbZD0Plr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:41:47 -0400
Subject: Re: [PATCH 1/3] bitops: Add __ffs64 bitop
From: Steven Whitehouse <swhiteho@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <52615.1240839635@turing-police.cc.vt.edu>
References: <1240478216-2594-1-git-send-email-swhiteho@redhat.com>
	 <1240478216-2594-2-git-send-email-swhiteho@redhat.com>
	 <52615.1240839635@turing-police.cc.vt.edu>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 27 Apr 2009 16:41:06 +0100
Message-Id: <1240846866.29604.122.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-04-27 at 09:40 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 23 Apr 2009 10:16:54 BST, Steven Whitehouse said:
> > Finds the first set bit in a 64 bit word. This is required in order
> > to fix a bug in GFS2, but I think it should be a generic function
> > in case of future users.
> 
> Seems like a sane idea..
> 
> > +static inline unsigned long __ffs64(u64 word)
> > +{
> > +#if BITS_PER_LONG == 32
> > +	if (((u32)word) == 0UL)
> > +		return __ffs((u32)(word >> 32)) + 32;
> > +#elif BITS_PER_LONG != 64
> > +#error BITS_PER_LONG not 32 or 64
> > +#endif
> > +	return __ffs((unsigned long)word);
> > +}
> > +
> 
> Does this have endian-ness issues (is that (u32)word the "high" or "low"
> part)?  Or is this intended only for looking at bitmaps and the like, and we
> don't really care?

The intent was that it would operate on native endian u64 words so that
it shouldn't be affected by the endianess. In the GFS2 code where it is
used, the byte ordering is converted to native order before this
function is applied,

Steve.



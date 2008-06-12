Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbYFLT1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbYFLT1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYFLT1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:27:14 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47066 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbYFLT1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:27:13 -0400
Subject: Re: [PATCH 6/6] ext4: tighten restrictions on inode flags
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Duane Griffin <duaneg@dghda.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, Andreas Dilger <adilger@sun.com>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <e9e943910806110449sbf30bf6xd98840fcd343519d@mail.gmail.com>
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-5-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-6-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-7-git-send-email-duaneg@dghda.com>
	 <20080611113104.GC9008@skywalker>
	 <e9e943910806110449sbf30bf6xd98840fcd343519d@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 14:27:07 -0500
Message-Id: <1213298827.6382.2.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-11 at 12:49 +0100, Duane Griffin wrote:
> 2008/6/11 Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>:
> >> +/* Mask out flags that are inappropriate for the given type of inode. */
> >> +static inline __le32 ext4_mask_flags(__le16 mode, __le32 flags)
> >> +{
> >> +     if (S_ISDIR(mode))
> >> +             return flags;
> >> +     else if (S_ISREG(mode))
> >> +             return flags & ~EXT4_REG_FLMASK;
> >> +     else
> >> +             return flags & ~EXT4_OTHER_FLMASK;
> >> +}
> >> +
> >
> > why are the arguments __le32 ? They should be in host order.
> >
> > static inline  __u32 ext4_mask_flags(umode_t mode, __u32 flags)
> 
> Whoops, I was matching the fields in ex4_inode, but I should have been
> looking at ext4_inode_info. Shouldn't sparse have complained about
> that?

It does, but not by default.  You need to run sparse with
-D__CHECK_ENDIAN__

I use this alias:
make_sparse is aliased to `make C=2 CF="-D__CHECK_ENDIAN__"'

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center


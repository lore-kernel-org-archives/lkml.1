Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYCJMmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYCJMmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 08:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYCJMlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 08:41:52 -0400
Received: from mx.sz.bfs.de ([194.94.69.70]:42209 "EHLO mx.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbYCJMlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 08:41:51 -0400
X-Greylist: delayed 1230 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2008 08:41:50 EDT
Message-ID: <47D52785.80907@bfs.de>
Date: Mon, 10 Mar 2008 13:20:21 +0100
From: walter harms <WHarms@bfs.de>
Reply-To: WHarms@bfs.de
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: e1000-devel@lists.sourceforge.net, xfs-masters <xfs-masters@oss.sgi.com>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [E1000-devel] [PATCH] drivers/net: convert & to &&
References: <Pine.LNX.4.58.0803061841000.1669@pc-041.diku.dk>	 <1204826347.5541.20.camel@localhost>  <47D032FA.9000909@intel.com> <1204914033.5541.74.camel@localhost>
In-Reply-To: <1204914033.5541.74.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Joe Perches wrote:
> On Thu, 2008-03-06 at 10:07 -0800, Kok, Auke wrote:
>> (which, BTW also could use the uint32_t -> u32 (etc) changes... while you're at it)
> 
> I think this does what you want:
> 
> for size in "8" "16" "32" "64" ; do \
> sed -r -i -e 's/\bu_{0,1}int'$size'_t\b/u'$size'/g' \
> $(grep -rPlw --include=*.[ch] 'u_{0,1}int'$size'_t' drivers/net/e1000 drivers/net/ixgb); done
> 
> But why?  boolean_t is used by 3 subsystems with local typedefs.
> These others are much more frequently used by kernel source.
> 
> $ grep -rPlw --include=*.[ch] "u{0,1}_{0,1}int(8|16|32|64)_t" * | wc -l
> 876
> 
> include/linux/types.h has typedefs for these but not boolean_t
> 
> include/linux/types.h:typedef           __u8            u_int8_t;
> include/linux/types.h:typedef           __s8            int8_t;
> include/linux/types.h:typedef           __u16           u_int16_t;
> include/linux/types.h:typedef           __s16           int16_t;
> include/linux/types.h:typedef           __u32           u_int32_t;
> include/linux/types.h:typedef           __s32           int32_t;
> include/linux/types.h:typedef           __u8            uint8_t;
> include/linux/types.h:typedef           __u16           uint16_t;
> include/linux/types.h:typedef           __u32           uint32_t;
> include/linux/types.h:typedef           __u64           uint64_t;
> include/linux/types.h:typedef           __u64           u_int64_t;
> include/linux/types.h:typedef           __s64           int64_t;
> 

Why not the other way around ?
inttypes.h is C99 and defines int16_t (or uint16_t). i do not see any reason
not to use them or any other type (like __u8) that does actually the same.

In that case we do not need different type names for userspace/kernelspace, or is there an other name
for int ? in that case we can remove the whole heap of typedef's.

re,
 wh




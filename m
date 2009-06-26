Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbZFZVle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbZFZVle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 17:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZFZVlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 17:41:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51543 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZFZVlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 17:41:23 -0400
Message-ID: <4A45405A.1010404@zytor.com>
Date: Fri, 26 Jun 2009 14:40:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: tridge@samba.org
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
References: <19013.8005.541836.436991@samba.org>
In-Reply-To: <19013.8005.541836.436991@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org wrote:
> This is a new patch for VFAT long filename support, replacing the one
> that I posted last month. It retains a lot more functionality then the
> previous patch.
> 
> A FAQ will be posted immediately after this patch to answer the
> questions that were raised from the previous discussion.
> 

>From a purely technical perspective, there is a major advantage to this
patch: it creates a "pure VFAT" filesystem, without a spurious filename
alias which still occupies namespace, hiddenly, and therefore could
cause an ill-defined amount of problems.  UMSDOS at least had the
decency to not expose its shortnames to a longname-aware OS.

However, as such it really should be paired with a "don't even recognize
the shortname if a longname exists" option.

It's also questionable IMO if this shouldn't be another FAT superdriver,
just as we have VFAT, MS-DOS etc. we could have "purevfat".

	-hpa

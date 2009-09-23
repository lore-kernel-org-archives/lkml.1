Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZIWPO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZIWPO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZIWPO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:14:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbZIWPO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:14:26 -0400
Date: Wed, 23 Sep 2009 08:13:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: change sys_truncate/sys_ftruncate length parameter
 type
In-Reply-To: <20090923150326.GB23595@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.2.01.0909230808130.4950@localhost.localdomain>
References: <20090923150326.GB23595@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Sep 2009, Heiko Carstens wrote:
> 
> For both system calls user space passes a signed long length parameter,
> while the kernel side takes an unsigned long parameter and converts it
> later to signed long again.

No it doesn't.

Look at sys_ftruncate() again. It doesn't convert it to signed long at 
all. It converts it to 'loff_t' which is something different entirely.

Now, it may be that we _should_ convert it to 'long' like your patch does, 
but this is definitely not a "no changes" patch as far as I can tell. It 
limits ftruncate to 31 bits on 32-bit architectures, in ways it didn't use 
to be limited.

[ Note the "small" logic and the interaction with O_LARGEFILE. On a 32-bit 
  architecture, if you open with O_LARGEFILE, ftruncate() gets the full 
  32-bit range, and that's the part your patch broke. ]

So NAK. Not without some serious explanations on why I'm wrong and am just 
being unnecessarily difficult and a pinhead.

			Linus

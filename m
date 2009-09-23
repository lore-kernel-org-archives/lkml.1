Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZIWQbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZIWQbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZIWQbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:31:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56383 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZIWQbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:31:34 -0400
Message-ID: <4ABA4D53.2040607@zytor.com>
Date: Wed, 23 Sep 2009 09:31:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: change sys_truncate/sys_ftruncate length parameter
 type
References: <20090923150326.GB23595@osiris.boeblingen.de.ibm.com> <alpine.LFD.2.01.0909230808130.4950@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909230808130.4950@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Look at sys_ftruncate() again. It doesn't convert it to signed long at 
> all. It converts it to 'loff_t' which is something different entirely.
> 
> Now, it may be that we _should_ convert it to 'long' like your patch does, 
> but this is definitely not a "no changes" patch as far as I can tell. It 
> limits ftruncate to 31 bits on 32-bit architectures, in ways it didn't use 
> to be limited.
> 
> [ Note the "small" logic and the interaction with O_LARGEFILE. On a 32-bit 
>   architecture, if you open with O_LARGEFILE, ftruncate() gets the full 
>   32-bit range, and that's the part your patch broke. ]
> 

I would argue that the current behavior is, if not incorrect (we define 
our own ABI after all) at least unwanted (we want our ABI to be as close 
as practical to the POSIX API.)

In particular, at the API level, both truncate() and ftruncate does take 
a signed (off_t) parameter, and the POSIX spec states:

        The ftruncate() function shall fail if:

        EINVAL The length argument was less than 0.

So yes, it's a change, but it seems to be one which probably should be done.

> In addition if hpa comes up with an automated way of generating
> compat wrappers it would generate wrong ones for these two cases.

I really mean to try to shake free some time and do that project.  I 
don't think it will happen before Kernel Summit, though :(

	-hpa


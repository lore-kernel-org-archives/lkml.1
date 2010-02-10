Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0BJLax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 06:30:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:53965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab0BJLav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 06:30:51 -0500
Message-ID: <4B729A42.102@kernel.org>
Date: Wed, 10 Feb 2010 20:36:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org>
In-Reply-To: <4B7296DF.207@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Feb 2010 11:29:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 08:22 PM, Tejun Heo wrote:
> So, I don't think it's feasible to do the address matching from inside
> the kernel without a lot of convolution.

To clarify a bit.  The alignment is still a must.  What's
theoretically feasible with convolution is hiding the alignment from
the userland server by adjusting virtual addresses of maps, but this
will visibly break alignment as seen from the clients (e.g. client may
not be able to unmap part of existing mmap and mmap SHMLBA aligned
disjoint part there) even if we ignore the fact that implementation
would be so invasive to the vm layer that it has no possibility of
getting accepted.

SHMLBA is something that a user of shm should know anyway.  I don't
think it's too much to ask for from FUSE servers which would implement
direct mmap and it's easy to detect and enforce too.  The proposed
libfuse patch abort()s if the condition is not met.

Thanks.

-- 
tejun

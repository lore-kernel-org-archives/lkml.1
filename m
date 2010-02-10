Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab0BJM25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 07:28:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:57622 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab0BJM2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 07:28:55 -0500
Message-ID: <4B72A802.6040009@kernel.org>
Date: Wed, 10 Feb 2010 21:35:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Feb 2010 12:28:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Miklos.

On 02/10/2010 09:15 PM, Miklos Szeredi wrote:
>> Same offset -> same page doesn't hold.
> 
> Right, I really meant same page -> same offset.  If the same offset is
> mapped to multiple pages: no problem.  If the same page is mapped to
> multiple offsets, then obviously it's not going to work properly.

Yeap.

>> Can you please elaborate how you think the thing can work without
>> referencing the proposed implementation?  Let's find out where the
>> misundertanding is.
> 
> Thinking about it I'm not really sure...
> 
> Maybe the problem is that the propsed solution allows too much
> freedom.  Normally there's a 1:1 relationship between pages and
> offsets.  But we want to break that for CUSE, because two different
> mappings of a char dev might point to completely different pages,
> right?

Yeap.  It basically behaves like each mmap() instance is a shm
instance and the offset into dmmap_regions is the shmkey.

> When does that happen?  Can it happen that two mappings of the same
> file descriptor will have different backing pages?

Yeah, sure.  FUSE server is free to give them separate regions.  The
only restriction is the SHMLBA alignment which is pretty easy to
adhere to.

Thanks.

-- 
tejun

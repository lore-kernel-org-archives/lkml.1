Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYLFXdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYLFXdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 18:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYLFXdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 18:33:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49852 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbYLFXdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 18:33:32 -0500
Message-ID: <493B0BAD.10004@redhat.com>
Date: Sat, 06 Dec 2008 17:33:01 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Harald Arnesen <skogtun.harald@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [ext4] Documentation patch
References: <8763m3u9kv.fsf@basilikum.skogtun.org> <20081201165700.GA26680@infradead.org> <493425DC.1010008@redhat.com> <20081201205828.GA20069@mit.edu> <20081206222534.GJ1323@mit.edu>
In-Reply-To: <20081206222534.GJ1323@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> This is what I have added to the ext4 patch queue.
> 
> 							- Ted
> 
> Update Documentation/filesystems/ext4.txt
> 
> Fix paragraph with recommendations on how to tune ext4 for benchmarks.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
> index 845e691..19bb93f 100644
> --- a/Documentation/filesystems/ext4.txt
> +++ b/Documentation/filesystems/ext4.txt
> @@ -58,13 +58,18 @@ Note: More extensive information for getting started with ext4 can be
>  
>  	# mount -t ext4 /dev/hda1 /wherever
>  
> -  - When comparing performance with other filesystems, remember that
> -    ext3/4 by default offers higher data integrity guarantees than most.
> -    So when comparing with a metadata-only journalling filesystem, such
> -    as ext3, use `mount -o data=writeback'.  And you might as well use
> -    `mount -o nobh' too along with it.  Making the journal larger than
> -    the mke2fs default often helps performance with metadata-intensive
> -    workloads.
> +  - When comparing performance with other filesystems, it's always
> +    important to try multiple workloads; very often a subtle change in a
> +    workload parameter can completely change the ranking of which
> +    filesystems do well compared to others.  When comparing versus ext3,
> +    note that ext4 enables write barriers by default, while ext3 does
> +    not enable write barriers by default.  So it is useful to use
> +    explicitly specify whether barriers are enabled or not when via the
> +    '-o barriers=[0|1]' mount option.  

That sentence doesn't quite parse...

> + When tuning ext3 for best
> +    benchmark numbers, it is often worthwhile to try changing the data
> +    journaling mode; '-o data=writeback,nobh' can be faster for some
> +    workloads.  

It should probably be made obvious that this has a security implication
(stale data exposed, right?)

-Eric

> + A large journal can also be helpful for
> +    metadata-intensive workloads.
>  
>  2. Features
>  ===========


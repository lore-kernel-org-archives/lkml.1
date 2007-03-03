Return-Path: <linux-kernel-owner+w=401wt.eu-S1030624AbXCCW6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030624AbXCCW6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030626AbXCCW6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:58:51 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:2845 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030624AbXCCW6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:58:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BY6grTztbtdaAjarFbcqPyCOvmFYpkcNVLC3Pm9y1/TCWEqz6zpCW1F5G8pT8RU22sE9uzc/vOxSQef7SuqeHzwSsAKdHf+lb+UPqJQOCVdku11DV4HtILAZNIuSHIqbd6HeVOMGu9I6Fehmhmafof/X88mbJoPm071apFJzK/U=
Message-ID: <2c0942db0703031458i540c496fib892240619faa9b2@mail.gmail.com>
Date: Sat, 3 Mar 2007 14:58:48 -0800
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: userspace pagecache management tool
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070303122935.f1ab0067.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> It is to address the "waah, backups fill my memory with pagecache" and the
> "waah, updatedb swapped everything out" and the "waah, copying a DVD
> gobbled all my memory" problems.

Is the updatedb problem really due to pagecache?

> When running
>
>         pagecache-management.sh dd if=100-mb-file of=foo
>         or
>         pagecache-management.sh cp -a /usr/src/linux-2.6.20 /usr/src/foo
>
> the amount of pagecache in the machine is pretty much unaltered.  Maybe a
> megabyte of additional cache in the second case, because of ext3 indirect
> blocks.

ray@phoenix:~/work/home/pagecache-management$ grep ext3_i
/proc/slabinfo; ./pagecache-management.sh sudo updatedb; grep ext3_i
/proc/slabinfo
ext3_inode_cache   21024  23722   1584    2    1 : tunables   24   12
  0 : slabdata  11861  11861      0
ext3_inode_cache   41332  41332   1584    2    1 : tunables   24   12
  0 : slabdata  20666  20666      0
ray@phoenix:~/work/home/pagecache-management$ echo $(( 1584 * (41332-21024) ))
32167872

Or is there a /proc/sys/vm/* knob that can be tweaked for this
before/after the updatedb?

But yeah, I for one would happily submit patches to upstream authors
to address this there. There's no reason code should be making the
kernel guess its intention on these things.

Ray

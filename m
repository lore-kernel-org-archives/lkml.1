Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbYEMJBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbYEMJBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbYEMJBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:01:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:15901 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbYEMJBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:01:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PShXSGgAgKw0suo+Z8b3agCkKHikW34xFmwBCn9IaYgvUePOh7cpzPq1YmMShwWFWYAHhFhW/uu2wpNd/aWHZxeZF9+JXBAaRHsvthC+3Te5AU+085DPffpg5Y3yDlyqJb6mwCzeA9AJsNLgIgHG5CwWbhO468HrnE2bzK/gviI=
Message-ID: <19f34abd0805130201q1a7e7617k8d260b3e229077bc@mail.gmail.com>
Date: Tue, 13 May 2008 11:01:11 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: oprofile BUG() in current kernel.
Cc: arges@linux.vnet.ibm.com, "Maynard Johnson" <maynardj@us.ibm.com>,
       "Gianni Tedesco" <gxt@cs.nott.ac.uk>, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net, "Mike Travis" <travis@sgi.com>
In-Reply-To: <20080513014010.e0723e01.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210593756.3708.7.camel@dao.KWGR614>
	 <19f34abd0805120519t12fceef9u7870006a904c85b2@mail.gmail.com>
	 <1210599105.3479.1.camel@dao.KWGR614> <48285002.9080702@us.ibm.com>
	 <1210610283.7218.4.camel@snuffleupagus>
	 <20080513014010.e0723e01.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 10:40 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 12 May 2008 11:38:03 -0500 Chris J Arges <arges@linux.vnet.ibm.com> wrote:
>  > > >> Does reverting 608dfddd845da5ab6accef70154c8910529699f7 fix it for you too?
>  > > >>
>  > > Has this fix been officially reverted?
>  >
>
> > Let me know if this change is going to be reverted, as I have a patch
>  > ready to support cpu hotplug for oprofile based on code post
>  > DEFINE_PER_CPU patch.
>
>  Please don't top-post.  I repaired it so that I could reply sensibly.
>
>  In trying to reprocude this on a uniprocessor machine, it seems that
>  someone broke oprofile:
>
>  /usr/bin/opcontrol: line 911: /dev/oprofile/0/enabled: No such file or directory
>  /usr/bin/opcontrol: line 911: /dev/oprofile/0/event: No such file or directory
>  /usr/bin/opcontrol: line 911: /dev/oprofile/0/count: No such file or directory
>  /usr/bin/opcontrol: line 911: /dev/oprofile/0/kernel: No such file or directory
>  /usr/bin/opcontrol: line 911: /dev/oprofile/0/user: No such file or directory
>  /usr/bin/opcontrol: line 911: /dev/oprofile/0/unit_mask: No such file or directo
>
>  sony:/home/akpm> l /dev/oprofile
>  total 0
>  drwxr-xr-x 1 root root 0 May 13 01:25 1
>  -rw-r--r-- 1 root root 0 May 13 01:25 backtrace_depth
>  -rw-r--r-- 1 root root 0 May 13 01:25 buffer
>  -rw-r--r-- 1 root root 0 May 13 01:25 buffer_size
>  -rw-r--r-- 1 root root 0 May 13 01:25 buffer_watershed
>  -rw-r--r-- 1 root root 0 May 13 01:25 cpu_buffer_size
>  -rw-r--r-- 1 root root 0 May 13 01:25 cpu_type
>  -rw-rw-rw- 1 root root 0 May 13 01:25 dump
>  -rw-r--r-- 1 root root 0 May 13 01:25 enable
>  -rw-r--r-- 1 root root 0 May 13 01:25 pointer_size
>  drwxr-xr-x 1 root root 0 May 13 01:25 stats
>
>  Looks like the "0" got renamed to "1".  Who did that?

There's also a commit d18d00f5dbcd1a95811617e9812cf0560bd465ee with
the following text, which seems related?

"The existing code passed a reference to cpu 0's instance of struct op_msrs
    to model->shutdown, whilst the other functions are passed a reference to
    <this cpu's> instance of a struct op_msrs.  This seemed to be a bug to me
    even though as long as cpu 0 and <this cpu> are of the same type it would
    have the same effect...?"

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

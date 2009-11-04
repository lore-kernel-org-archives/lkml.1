Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951AbZKDGYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbZKDGYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZKDGYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:24:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473AbZKDGYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:24:47 -0500
Date: Tue, 3 Nov 2009 22:24:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@cs.washington.edu>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0,
 oom_adj=0
Message-Id: <20091103222432.4a94bd8f.akpm@linux-foundation.org>
In-Reply-To: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009 13:29:29 -0800 Justin Mattock <justinmattock@gmail.com> wrote:

> Hello,
> I'm not sure how to handle this,
> while compiling firefox-3.6b1.source
> I get this with the default compiling options,
> as well as custom:
> 
> ...
>
> active_anon:2360492kB inactive_anon:590196kB active_file:84kB

2.8GB of anonymous memory

> [  532.942508] Free swap  = 0kB
> [  532.942510] Total swap = 431632kB

430MB of swap, all used up.

That's a genuine OOM.  Something (presumably cc1plus) has consumed
waaaay too much memory, quite possibly leaked it.

It would help if the oom-killer were to print some information about
the oom-killed process's memory footprint.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYCRKMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYCRKMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 06:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYCRKMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 06:12:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46269 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYCRKL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 06:11:59 -0400
Date: Tue, 18 Mar 2008 19:16:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH O/4] Block I/O tracking
Message-Id: <20080318191624.85ca135f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080318.182251.93858044.taka@valinux.co.jp>
References: <20080318.182251.93858044.taka@valinux.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 18:22:51 +0900 (JST)
Hirokazu Takahashi <taka@valinux.co.jp> wrote:

>  # mount -t cgroup -o bio none /cgroup/bio
> 
> Then, you make new bio cgroups and put some processes in them.
> 
>  # mkdir /cgroup/bio/bgroup1
>  # mkdir /cgroup/bio/bgroup2
>  # echo 1234 /cgroup/bio/bgroup1/tasks
>  # echo 5678 /cgroup/bio/bgroup1/tasks
> 
> Now you check the ids of the bio cgroups which you just created.
> 
>  # cat /cgroup/bio/bgroup1/bio.id
>    1
>  # cat /cgroup/bio/bgroup2/bio.id
>    2
> 
> Finally, you can attach the cgroups to "ioband1" and assign them weights.
> 
>  # dmsetup message ioband1 0 type cgroup
>  # dmsetup message ioband1 0 attach 1
>  # dmsetup message ioband1 0 attach 2
>  # dmsetup message ioband1 0 weight 1:30
>  # dmsetup message ioband1 0 weight 2:60
> 
> You can find the manual of dm-ioband at
> http://people.valinux.co.jp/~ryov/dm-ioband/manual/index.html.
> But the user interface for the bio cgroup is temporal and it will be
> changed after the io_context support. 
> 
I'm grad if these some kinds of params rather than 'id' are also shown
under cgroup.

Thanks,
-Kame





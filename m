Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbZDQC0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbZDQC0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 22:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZDQC0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:26:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34488 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbZDQC0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:26:09 -0400
Date: Fri, 17 Apr 2009 11:24:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Andrea Righi <righi.andrea@gmail.com>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
Message-Id: <20090417112433.085ed604.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49E7E037.9080004@oss.ntt.co.jp>
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>
	<1239740480-28125-4-git-send-email-righi.andrea@gmail.com>
	<49E7E037.9080004@oss.ntt.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 10:49:43 +0900
Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp> wrote:

> Hi,
> 
> I have a few question.
>    - I have not yet fully understood how your controller are using
>      bio_cgroup. If my view is wrong please tell me.
> 
> o In my view, bio_cgroup's implementation strongly depends on
>    page_cgoup's. Could you explain for what purpose does this
>    functionality itself should be implemented as cgroup subsystem?
>    Using page_cgoup and implementing tracking APIs is not enough?

I'll definitely do "Nack" to add full bio-cgroup members to page_cgroup.
Now, page_cgroup is 40bytes(in 64bit arch.) And all of them are allocated at
boot time as memmap. (and add member to struct page is much harder ;)

IIUC, feature for "tracking bio" is just necesary for pages for I/O.
So, I think it's much better to add misc. information to struct bio not to the page.
But, if people want to add "small hint" to struct page or struct page_cgroup
for tracking buffered I/O, I'll give you help as much as I can.
Maybe using "unused bits" in page_cgroup->flags is a choice with no overhead.

Thanks,
-Kame


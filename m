Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbYGRPrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbYGRPrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbYGRPrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:47:04 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31162 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYGRPrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:47:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=I6lphC74A54ykOkP1FlpgrvbmkkQEE3N638jVxylL+WTgYAutSwWg2A7ubBKQfZKm
	naYXfDUYcXzBiZubWEswg==
Message-ID: <6599ad830807180846n11260adft168bddf7c203469c@mail.gmail.com>
Date: Fri, 18 Jul 2008 08:46:55 -0700
From: "Paul Menage" <menage@google.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Cc: "Vivek Goyal" <vgoyal@redhat.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Libcg Devel Mailing List" <libcg-devel@lists.sourceforge.net>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Peter Zijlstra" <pzijlstr@redhat.com>,
       "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080718185226.f809281d.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701191126.GA17376@redhat.com>
	 <20080718185226.f809281d.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 2:52 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> For example, create a new file under memory cgroup
> ==
>  /opt/memory_cgroup/group_A/notify_at_memory_reach_limit
> ==
> And a user watches the file by inotify.
> The kernel modify modified-time of notify_at_memory_reach_limit file and call
> fs/notify_user.c::notify_change() against this inode. He can catchthe event
> by inotify.
> (I think he can also catch removal of this file, etc...)
>

We've been doing something like this to handle OOMs in userspace, with
pretty good success. The approach that we used so far was a custom
control file tied to a wait queue, that gets woken when a cgroup
triggers OOM, but it's a bit hacky. I've been considering some kind of
more generic approach that could be reused by different subsystems for
other notifications, maybe using eventfd or maybe netlink.

inotify would be an option too, but that seems like it might be
forcing ourselves into filesystem semantics too much.

Paul

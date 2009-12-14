Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbZLNMxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbZLNMxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZLNMxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:53:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37542 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbZLNMxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:53:34 -0500
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "Li, Haicheng" <haicheng.li@intel.com>
Subject: Re: [PATCH] [23/31] HWPOISON: add memory cgroup filter
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
	<20091208211639.8499FB151F@basil.firstfloor.org>
	<6599ad830912091247v1270a86er45ea8ceeff28e727@mail.gmail.com>
	<20091210014212.GI18989@one.firstfloor.org>
	<20091210022113.GJ3722@balbir.in.ibm.com>
	<20091211021405.GA10693@localhost>
Date: Mon, 14 Dec 2009 13:53:30 +0100
In-Reply-To: <20091211021405.GA10693@localhost> (Wu Fengguang's message of "Fri, 11 Dec 2009 10:14:05 +0800")
Message-ID: <87tyvtyawl.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> writes:
>
> We could keep an fd open on the desired cgroup, in user space: 
>
>         #!/bin/bash
>
>         mkdir /cgroup/hwpoison && \
>         exec 9<>/cgroup/hwpoison/tasks || exit 1
>
> A bit simpler than an in-kernel fget_light() or CSS refcount :)

FYI, I decided to not do any of this in .33, but just keep the 
ugly-but-working inode hack. We can look at fixing that for .34.
These interfaces are debugfs, so can be changed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

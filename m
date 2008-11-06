Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYKFBPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYKFBPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 20:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYKFBPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 20:15:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39213 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbYKFBPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 20:15:37 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: /proc/pid/maps containg anonymous maps that have PROT_NONE
Cc: kosaki.motohiro@jp.fujitsu.com,
       =?SHIFT_JIS?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0811051541470.19714@blonde.site>
References: <49118010.20202@gmail.com> <Pine.LNX.4.64.0811051541470.19714@blonde.site>
Message-Id: <20081106100727.0D35.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  6 Nov 2008 10:15:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [pid 31928] mmap(NULL, 134217728, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0 <unfinished ...>
> [pid 31938] futex(0x7ffff6e489e0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
> [pid 31928] <... mmap resumed> )        = 0x7fffe2bd3000
> 
>   which maps 7fffe2bd3000-7fffeabd3000; then
> 
> [pid 31928] munmap(0x7fffe2bd3000, 21155840 <unfinished ...>
> [pid 31938] <... futex resumed> )       = 0
> [pid 31928] <... munmap resumed> )      = 0
> 
>   which unmaps 7fffe2bd3000-7fffe4000000; and then
> 
> [pid 31928] munmap(0x7fffe8000000, 45953024) = 0
> 
>   which unmaps 7fffe8000000-7fffeabd3000.
> 
> So it's trimming off the rough edges to leave 7fffe4000000-7fffe8000000
> mapped PROT_NONE, then mprotecting what it needs of that.
> 
> Why does it mmap too much then trim it down?  Perhaps it's trying to
> minimize pagetable usage, perhaps it's internally convenient to base
> on rounded addresses, I don't know.

Yup.

glibc malloc's arena need heap size alignment.
it cause that struct arena address can calcurate "arena = any_ptr & ~(HEAP_SIZE-1)"
as old linux's "current" macro calculation.


> But the mmap is there: just easily overlooked because of the way it
> munmaps too (with strace showing hex addresses but decimal sizes).






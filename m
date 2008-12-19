Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYLSKFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYLSKFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 05:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYLSKFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 05:05:23 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37288 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYLSKFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 05:05:22 -0500
X-AuditID: 0ac90647-ac0f7ba000000f8c-ea-494b71e092bd
Message-ID: <494B71D6.3080602@hitachi.com>
Date: Fri, 19 Dec 2008 19:05:10 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, yumiko.sugita.yf@hitachi.com,
       satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH] coredump_filter: enable to change the default filter
References: <4940B426.6040509@hitachi.com> 
    <20081211154349.5000.KOSAKI.MOTOHIRO@jp.fujitsu.com> 
    <20081211151003.00572e04.akpm@linux-foundation.org> 
    <20081211232205.ED188FC3AB@magilla.sf.frob.com>
In-Reply-To: <20081211232205.ED188FC3AB@magilla.sf.frob.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Roland McGrath wrote:

>>Or does the patch change other behaviour?  Say, when mm_init() is
>>called by a kernel thread (current->mm==NULL)?  call_usermodehelper(),
>>for example?
>>
>>If so, then setting init's filter doesn't cover that case.
> 
> Hmm, probably for the kernel thread case mm_init should use
> task_active_pid_ns(current)->child_reaper->mm->flags.

It makes sense.  It also enables us to change coredump_filter for
user mode helpers after the system was booted.

However, we would need a special care for PID namespace if we use
init's coredump_filter as default.  For a process with new PID
namespace and new /proc, writing to /proc/1/coredump_filter doesn't
mean changing default, although it's not a usual operation.

The reason why I suggested the boot parameter way is most users
can change the default easily.  Some users have difficulty to
change init scripts for various reasons.

So I think the boot parameter way is simpler for both users and
kernel developers.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


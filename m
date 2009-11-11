Return-Path: <linux-kernel-owner+w=401wt.eu-S1751585AbZKKFvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbZKKFvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 00:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbZKKFvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 00:51:04 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:65462 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZKKFvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 00:51:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eZLsfff/jrlLpDOGavdvH36y5PvOfBSO4ysDP0fOKTly9dxHfJDiqoS4/LeIHIKCL+
         7uKLGLaf7nne4dJrnyGWsAEv4vhjDDXIZxvJuNKsCiMu9Iqb9YN/PznJPeUQeTlrcRhU
         +ZbyPogH3QxgIxufNPZDYwdBt+D1/8djMbWQE=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0911102202500.2816@sister.anvils>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils>
	 <Pine.LNX.4.64.0911102202500.2816@sister.anvils>
Date: Wed, 11 Nov 2009 14:51:08 +0900
Message-ID: <28c262360911102151n349bd2a5x2749f1cb5653ed43@mail.gmail.com>
Subject: Re: [PATCH 6/6] mm: sigbus instead of abusing oom
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 7:06 AM, Hugh Dickins
<hugh.dickins@tiscali.co.uk> wrote:
> When do_nonlinear_fault() realizes that the page table must have been
> corrupted for it to have been called, it does print_bad_pte() and
> returns ... VM_FAULT_OOM, which is hard to understand.
>
> It made some sense when I did it for 2.6.15, when do_page_fault()
> just killed the current process; but nowadays it lets the OOM killer
> decide who to kill - so page table corruption in one process would
> be liable to kill another.
>
> Change it to return VM_FAULT_SIGBUS instead: that doesn't guarantee
> that the process will be killed, but is good enough for such a rare
> abnormality, accompanied as it is by the "BUG: Bad page map" message.
>
> And recent HWPOISON work has copied that code into do_swap_page(),
> when it finds an impossible swap entry: fix that to VM_FAULT_SIGBUS too.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
I already agreed this. :)
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim

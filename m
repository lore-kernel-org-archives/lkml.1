Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbXC2H0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbXC2H0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 03:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXC2H0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 03:26:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50930 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbXC2H0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 03:26:03 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Linux-VServer example results for sharing vs. separate mappings  ...
To: Ethan Solomita <solo@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Dave Hansen <hansendc@us.ibm.com>
Reply-To: 7eggert@gmx.de
Date: Thu, 29 Mar 2007 09:24:43 +0200
References: <81XMo-Fl-19@gated-at.bofh.it> <827iC-6DZ-7@gated-at.bofh.it> <82jjS-89s-11@gated-at.bofh.it> <82l2j-2lv-11@gated-at.bofh.it> <82qEC-2yM-9@gated-at.bofh.it> <83v9d-3kf-1@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HWozz-0000gh-By@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/PZ9ZFYqjQlF7jERmacj8yiLzcZJFP2qSVWuL
 EuXxMBHPasaO8E19GeBJU3dSjnPvmi0GUt5MKz9PniZOBpWR7V
 q4TPsvCNe6c068lM2y8fw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ethan Solomita <solo@google.com> wrote:

>     I suggest a variant on what Andrew says: don't change reclaim.
> Instead, when referencing a page, don't mark the page as referenced if
> the current task is not permitted to allocate from the page's node. I'm
> thinking in terms of cpusets, with each task having a nodemask of
> mems_allowed. This may result in a page being thrown out unnecessarily
> and brought back in from disk, but when memory is tight that is what
> happens. An optimization might be to keep track of who is referencing
> the page and migrate it to their memory instead of reclaiming it, but
> that would require reclaim to know the task/cpuset/container of the
> referencing task.

If you are neaar reclaim and the page from that other node hasn't been
touched recently, maybe you could steal it. Off cause this is only
applicable if the checks are cheap enough.
-- 
Funny quotes:
40. Isn't making a smoking section in a restaurant like making a peeing
    section in a swimming pool?
Friﬂ, Spammer: t8nfgqx@jI9y.7eggert.dyndns.org uScowqPjo@i.7eggert.dyndns.org

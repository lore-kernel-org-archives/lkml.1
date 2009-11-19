Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZKSNaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZKSNaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbZKSNaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:30:23 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:57159 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZKSNaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:30:22 -0500
X-Greylist: delayed 1952 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Nov 2009 08:30:22 EST
X-AuditID: b753bd60-ab846ba000006009-21-4b0540d2906b
Message-ID: <4B0540C1.3060605@hitachi.com>
Date: Thu, 19 Nov 2009 21:57:37 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH -tip 2/2] Pass mm->flags as a coredump parameter for	consistency
References: <20091117235305.30900.43344.stgit@dhcp-100-2-132.bos.redhat.com> <20091117235401.30900.70697.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091117235401.30900.70697.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hiramatsu-san,

Masami Hiramatsu wrote:

>> Pass mm->flags as a coredump parameter for consistency.
>> 
>>  ---
>> 1787         if (mm->core_state || !get_dumpable(mm)) {  <- (1)
>> 1788                 up_write(&mm->mmap_sem);
>> 1789                 put_cred(cred);
>> 1790                 goto fail;
>> 1791         }
>> 1792
>> [...]
>> 1798         if (get_dumpable(mm) == 2) {    /* Setuid core dump mode */ <-(2)
>> 1799                 flag = O_EXCL;          /* Stop rewrite attacks */
>> 1800                 cred->fsuid = 0;        /* Dump root private */
>> 1801         }
>>  ---
>> 
>> Since dumpable bits are not protected by lock, there is a
>> chance to change these bits between (1) and (2).

Yes, a race condition can be caused by prctl from another thread.
And your patch is fine with me.  Thanks!

Reviewed-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
--
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


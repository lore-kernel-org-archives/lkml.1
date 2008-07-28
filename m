Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbYG1G0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbYG1G0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 02:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYG1G0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 02:26:36 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44803 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYG1G0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 02:26:35 -0400
X-AuditID: 0ac90647-ad2a4ba0000028e2-5d-488d669898ec
Message-ID: <488D668E.3030406@hitachi.com>
Date: Mon, 28 Jul 2008 15:26:22 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: akpm@linux-foundation.org
Cc: sct@redhat.com, adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz, jbacik@redhat.com,
       cmm@us.ibm.com, tytso@mit.edu, snitzer@gmail.com, tglx@linutronix.de,
       yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH 3/4] ext3: abort ext3 if the journal has aborted
References: <488876D3.80004@hitachi.com> <4888782E.2050102@hitachi.com>
In-Reply-To: <4888782E.2050102@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 4. when checkpointing fails, notify this error to the ext3 layer so
>    that ext3 don't clear the needs_recovery flag, otherwise the
>    journaled contents are ignored and cleaned in the recovery phase

Mike Snitzer noticed that ext3_mark_recovery_complete() doesn't
check checkpointing failure and it clears needs_recovery flag 
(thanks, Mike!).  I need an additional fix.

I also found ext3_quota_on() forces checkpointing by journal_flush()
but it doesn't check the error.  This will appear in 2.6.27-rc1,
so I'll send the revised patch set for 2.6.27-rc1 (it may be
a separate patch).

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center


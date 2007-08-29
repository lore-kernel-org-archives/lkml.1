Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbXH2VTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbXH2VTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 17:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXH2VTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 17:19:04 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42215 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbXH2VTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 17:19:02 -0400
Date: Wed, 29 Aug 2007 14:18:59 -0700
From: sukadev@us.ibm.com
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use same_thread_group() in signalfd.c
Message-ID: <20070829211859.GB18542@us.ibm.com>
References: <46D57274.3040802@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D57274.3040802@openvz.org>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov [xemul@openvz.org] wrote:
| This is a lost hunk of previous patch that isolated the
| explicit usage of task->tgid in some places. The signalfd
| code uses the tsk->tgid comparison.
| 
| Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Acked-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>

| 
| ---
| 
| diff --git a/fs/signalfd.c b/fs/signalfd.c
| index a8e293d..5bfd2c5 100644
| --- a/fs/signalfd.c
| +++ b/fs/signalfd.c
| @@ -64,7 +64,7 @@ static int signalfd_lock(struct signalfd
| 		return 0;
| 	}
| 
| -	if (lk->tsk->tgid == current->tgid)
| +	if (same_thread_group(lk->tsk, current->tgid))
| 		lk->tsk = current;
| 
| 	return 1;

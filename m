Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbYEWPVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbYEWPVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYEWPVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:21:00 -0400
Received: from smtp.nokia.com ([192.100.122.233]:55990 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbYEWPU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:20:58 -0400
Message-ID: <4836E057.7020307@yandex.ru>
Date: Fri, 23 May 2008 18:18:47 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH take 2] UBIFS - new flash file system
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com> <20080516104002.GA6962@infradead.org>
In-Reply-To: <20080516104002.GA6962@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 May 2008 15:19:07.0008 (UTC) FILETIME=[57B6A000:01C8BCE8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>  - the mainoop of ubifs_bg_thread looks a bit odd either, when you
>    first to an interruotible sleep and then possible one while you
>    still have TASK_RUNNING set.  Also the need_bgt flag is not needed
>    because the thrad is only woken up to perform it's action.
>    In the end the main loop should look something like:
> 
> 	while (1) {
> 		if (kthread_should_stop())
> 			break;
> 		if (try_to_freeze())
> 			continue;
> 
> 		run_bg_commit(c);
> 
> 		set_current_state(TASK_INTERRUPTIBLE);
> 		schedule();
> 		__set_current_state(TASK_RUNNING);
> 	}

Err, how are we guaranteed that we do not miss wake-up events then,
if we were woken up say, between run_bg_commit(c) and
set_current_state(TASK_INTERRUPTIBLE) ? This was  the purpose
of the 'need_bgt' flag.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

Return-Path: <linux-kernel-owner+w=401wt.eu-S932902AbYETOpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbYETOpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbYETOpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:45:42 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39179 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbYETOpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:45:41 -0400
Message-ID: <4832E423.5040708@bull.net>
Date: Tue, 20 May 2008 16:45:55 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@vger.kernel.org
Subject: Re: [PATCH 1/8] Scaling msgmni to the amount of lowmem
References: <cfd18e0f0805200728j1f38d90s1f6355b71e2d76@mail.gmail.com>
In-Reply-To: <cfd18e0f0805200728j1f38d90s1f6355b71e2d76@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:
> Hello Nadia,
> 
> Regarding your:
> 
> [PATCH 1/8] Scaling msgmni to the amount of lowmem
> http://article.gmane.org/gmane.linux.kernel/637849/
> which I see has made its way in 2.6.26-rc
> 
> Your patch has the following change:
> 
> -#define MSGPOOL (MSGMNI*MSGMNB/1024)  /* size in kilobytes of message pool */
> +#define MSGPOOL (MSGMNI * MSGMNB) /* size in bytes of message pool */
> 
> Since this constitutes a kernel-userland interface change, so please
> do CC me, so that I can change the man pages if needed.

Oops, sorry for not doing it: I misunderstood the "unused"

> 
> The man page (http://www.kernel.org/doc/man-pages/online/pages/man2/msgctl.2.html)
> does indeed say that msgpool is "unused".  But that meant "unused by
> the kernel" (sorry -- I probably should have worded that text better).
>  And, as you spotted, the page also wrongly said the value is in
> bytes.
> 
> However, making this change affects the ABI.  A userspace application
> that was previously using msgctl(IPC_INFO) to retrieve the msgpool
> field will be affected by the factor-of-1024 change.  I strongly
> suspect that there no such applications, or certainly none that care
> (since this value is unused by the kernel).  But was there a reason
> for making this change, aside from the fact that the code and the man
> page didn't agree?
> 

No, that was the only reason.
Should I repost a patch to set it back as it used to be?

Regards
Nadia

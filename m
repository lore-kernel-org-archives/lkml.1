Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbYKQPbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbYKQPbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbYKQPbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:31:37 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:39548 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYKQPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:31:37 -0500
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Nov 2008 10:31:37 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ouZSAy/XOLBxxpF/Q8If5KUUtBqmofzHiTVXv0/Q0JU2/O42RUQ5S1bgvQci8LlDcK
         M5wpzKs+t28LNJCKluxCDGLVRnNbHBY3z5f9+hfCghJhySv2rrIY8yOHsJbqtr6yC82l
         eftuxMM43ylhQ10+1QcZlle1Px2Me4BpjASZY=
Date: Mon, 17 Nov 2008 15:23:02 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Denis V. Lunev" <den@openvz.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc: do not goto to the next line
Message-ID: <20081117152302.GC14976@hack.voiplan.pt>
References: <1226934652-23028-1-git-send-email-den@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226934652-23028-1-git-send-email-den@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 06:10:52PM +0300, Denis V. Lunev wrote:
>Signed-off-by: Denis V. Lunev <den@openvz.org>
>---
> ipc/sem.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
>
>diff --git a/ipc/sem.c b/ipc/sem.c
>index 0821224..b91d455 100644
>--- a/ipc/sem.c
>+++ b/ipc/sem.c
>@@ -1216,7 +1216,6 @@ asmlinkage long sys_semtimedop(int semid, struct sembuf __user *tsops,
> 	if (timeout && jiffies_left == 0)
> 		error = -EAGAIN;
> 	list_del(&queue.list);
>-	goto out_unlock_free;
> 
> out_unlock_free:
> 	sem_unlock(sma);

Aha, this goto is obviously useless. :)

If you need, 
Reviewed-by: WANG Cong <wangcong@zeuux.org>


-- 
"Sometimes the only way to stay sane is to go a little crazy."


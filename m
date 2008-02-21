Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbYBUIq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbYBUIq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYBUIqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:46:45 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:44749 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755781AbYBUIqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:46:44 -0500
X-Sasl-enc: XmLlECQv2wwhWMEMgAhECvLSKWbg8QH4vl0jaMOlrYWA 1203583602
Message-ID: <47BD3ADE.8040501@ladisch.de>
Date: Thu, 21 Feb 2008 09:48:30 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Joshua Roys <roysjosh@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH] [alsa-devel] Fix a compile warning under gcc-4.2.3.
References: <1203528197-24227-1-git-send-email-roysjosh@gmail.com>
In-Reply-To: <1203528197-24227-1-git-send-email-roysjosh@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joshua Roys wrote:
> sound/core/init.c: In function ‘snd_card_disconnect’:
> sound/core/init.c:307: warning: the address of ‘snd_shutdown_f_ops’ will always evaluate as ‘true’
>
> Signed-off-by: Joshua Roys <roysjosh@gmail.com>
> ---
>  sound/core/init.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/sound/core/init.c b/sound/core/init.c
> index 2cb7099..1afc58b 100644
> --- a/sound/core/init.c
> +++ b/sound/core/init.c
> @@ -304,7 +304,6 @@ int snd_card_disconnect(struct snd_card *card)
>  		list_add(&mfile->shutdown_list, &shutdown_files);
>  		spin_unlock(&shutdown_lock);
>
> -		fops_get(&snd_shutdown_f_ops);
>  		mfile->file->f_op = &snd_shutdown_f_ops;
>  		
>  		mfile = mfile->next;

This change may get rid of the warning, but is has the slight
disadvantage that the kernel will blow up if you try to unload the sound
modules before all device files have been closed.

If you want to get rid of this warning, tell the compiler that fops_get
knows what it does; or try making fops_get an inline function instead of
a macro.


Regards,
Clemens

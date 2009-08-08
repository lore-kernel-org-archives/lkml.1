Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbZHHJw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbZHHJw4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 05:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933920AbZHHJw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 05:52:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37184 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933776AbZHHJwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 05:52:55 -0400
Date: Sat, 8 Aug 2009 11:52:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, swetland@google.com, ibm@android.com,
       san@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dream, fix buf overflow
Message-ID: <20090808095249.GA9978@elf.ucw.cz>
References: <1249724038-1011-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249724038-1011-1-git-send-email-jirislaby@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-08-08 11:33:58, Jiri Slaby wrote:
> Not even compile-tested. I don't have an arm toolchain.
> --
> 
> In vfe_send_msg_no_payload there is a wrong struct vfe_message allocation.
> It allocates only sizeof(pointer to vfe_message) for a whole structure.
> Add a dereference to the sizeof to allocate sizeof(vfe_message).
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

(Google, you may want to fix this in your code, too.)

> ---
>  drivers/staging/dream/camera/msm_vfe8x_proc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/dream/camera/msm_vfe8x_proc.c b/drivers/staging/dream/camera/msm_vfe8x_proc.c
> index bb65013..5436f71 100644
> --- a/drivers/staging/dream/camera/msm_vfe8x_proc.c
> +++ b/drivers/staging/dream/camera/msm_vfe8x_proc.c
> @@ -818,7 +818,7 @@ static void vfe_send_msg_no_payload(enum VFE_MESSAGE_ID id)
>  {
>  	struct vfe_message *msg;
>  
> -	msg = kzalloc(sizeof(msg), GFP_ATOMIC);
> +	msg = kzalloc(sizeof(*msg), GFP_ATOMIC);
>  	if (!msg)
>  		return;
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

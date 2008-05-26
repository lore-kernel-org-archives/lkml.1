Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYEZPXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYEZPXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 11:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYEZPWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 11:22:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:34785 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbYEZPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 11:22:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BwTTA5BSLZm49pESMFljpzhvpkfR1v2zqEi6XibfFWKlcpYEUs5M8f1IIwC2fsviZNBlZuK1tXK5fwn3FUduMB+O1xJyili3kvuYByNPhFnyz4+xs+WeYNMzKEnaB/WSuylQwbACuRMQ8zn2HPpaTBRMLRKXh0IHhXIU7Ei3q9c=
Message-ID: <483AD5CC.4000507@gmail.com>
Date: Mon, 26 May 2008 17:22:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] Char: tty_io, fix closecount counting
References: <1211810923-3122-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1211810923-3122-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> filp->f_op->write never equals to tty_write for the console device, so
> closecount++ is never reached and we don't close console device so many
> times we open it before. (The closecount is used only for /dev/console.)
[...]
>  drivers/char/tty_io.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index c9e6e24..8c7b6ed 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -1434,9 +1434,9 @@ static void do_tty_hangup(struct work_struct *work)
>  	list_for_each_entry(filp, &tty->tty_files, f_u.fu_list) {
>  		if (filp->f_op->write == redirected_tty_write)
>  			cons_filp = filp;
> +		closecount++;
>  		if (filp->f_op->write != tty_write)
>  			continue;
> -		closecount++;

Hm, no, this is wrong.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZHMLn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZHMLn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbZHMLn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:43:26 -0400
Received: from mail-yw0-f193.google.com ([209.85.211.193]:40251 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZHMLnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lHArfMP/RMzvVQ0v1QJ2+ETtK3gxPWDlcmIWihEyqOAEwgaK73QYYirItrKolPZCUJ
         +UScyjNManYNoHcmk21vohtEVCu5jk3uXkMqBWZUlN+OIZdpXlpb/W9Gfe6EvLz1Rs+V
         lRdx/bDTYvsYwwO1/IaLevuhly3ckPGFGmlbg=
MIME-Version: 1.0
In-Reply-To: <1250138537.15796.18.camel@quadrophenia.thebigcorporation.com>
References: <1250138537.15796.18.camel@quadrophenia.thebigcorporation.com>
Date: Thu, 13 Aug 2009 13:35:50 +0200
Message-ID: <520f0cf10908130435t2aba0d23mb1465daef3a4a997@mail.gmail.com>
Subject: Re: [PATCH][RT] pty low latency
From: John Kacur <jkacur@gmail.com>
To: Sven-Thorsten Dietrich <sdietrich@novell.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 6:42 AM, Sven-Thorsten
Dietrich<sdietrich@novell.com> wrote:
>
> Subject: add hunks dropped in rt 2.6.31-rc5-rt1.1 forward port
> From: patch-2.6.31-rc4-rt1
> Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
> --- a/drivers/char/pty.c
> +++ b/drivers/char/pty.c
> @@ -52,6 +52,7 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
>                return;
>        tty->link->packet = 0;
>        set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
> +       tty_flip_buffer_push(tty->link);
>        wake_up_interruptible(&tty->link->read_wait);
>        wake_up_interruptible(&tty->link->write_wait);
>        if (tty->driver->subtype == PTY_TYPE_MASTER) {
> @@ -207,6 +208,7 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
>        clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
>        set_bit(TTY_THROTTLED, &tty->flags);
>        retval = 0;
> +       tty->low_latency = 1;
>  out:
>        return retval;
>  }
>

Thank You - I applied this.

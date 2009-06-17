Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbZFQGcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbZFQGcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 02:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZFQGcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 02:32:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbZFQGcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 02:32:23 -0400
Date: Tue, 16 Jun 2009 23:31:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Char: tty, fix tty_port_block_til_ready waiting
Message-Id: <20090616233152.41e43277.akpm@linux-foundation.org>
In-Reply-To: <1245179580-25402-1-git-send-email-jirislaby@gmail.com>
References: <1245179580-25402-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 21:13:00 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> Use DEFINE_WAIT instead of DECLARE_WAITQUEUE, because we use
> prepare/finish_wait since commit
> 3e3b5c087799e536871c8261b05bc28e4783c8da
> (tty: use prepare/finish_wait)
> 
> Otherwise we would oops in finish_wait.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/char/tty_port.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
> index 62dadfc..a8ed648 100644
> --- a/drivers/char/tty_port.c
> +++ b/drivers/char/tty_port.c
> @@ -193,7 +193,7 @@ int tty_port_block_til_ready(struct tty_port *port,
>  {
>  	int do_clocal = 0, retval;
>  	unsigned long flags;
> -	DECLARE_WAITQUEUE(wait, current);
> +	DEFINE_WAIT(wait, current);

That won't compile.  DEFINE_WAIT(wait) will though.

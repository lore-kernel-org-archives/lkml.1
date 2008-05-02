Return-Path: <linux-kernel-owner+w=401wt.eu-S1762765AbYEBJcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765AbYEBJcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbYEBJcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:32:45 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52199 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbYEBJco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:32:44 -0400
Date: Fri, 2 May 2008 12:31:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       Alan Cox <alan@redhat.com>
Subject: Re: [Patch] UML: Fix inconsistence due to tty_operation change
Message-ID: <20080502093152.GA4090@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.10.0805021450260.3349@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805021450260.3349@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Alan as tty maintainer added to Cc ]

On Fri, May 02, 2008 at 02:59:46PM +0800, WANG Cong wrote:
>
> 'put_char' of 'struct tty_operations' has changed from 'void' into 'int'.
> This can also shut up comipler warnings.

Not only, this could also be a runtime error.

> Cc: Jeff Dike <jdike@addtoit.com>
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
>
> ---
>
> diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
> index 10b86e1..5047490 100644
> --- a/arch/um/drivers/line.c
> +++ b/arch/um/drivers/line.c
> @@ -191,9 +191,9 @@ void line_flush_chars(struct tty_struct *tty)
>  	line_flush_buffer(tty);
>  }
>
> -void line_put_char(struct tty_struct *tty, unsigned char ch)
> +int line_put_char(struct tty_struct *tty, unsigned char ch)
>  {
> -	line_write(tty, &ch, sizeof(ch));
> +	return line_write(tty, &ch, sizeof(ch));
>  }
>
>  int line_write(struct tty_struct *tty, const unsigned char *buf, int len)
> diff --git a/arch/um/include/line.h b/arch/um/include/line.h
> index 1223f2c..979b73e 100644
> --- a/arch/um/include/line.h
> +++ b/arch/um/include/line.h
> @@ -71,7 +71,7 @@ extern int line_setup(struct line *lines, unsigned int sizeof_lines,
>  		      char *init, char **error_out);
>  extern int line_write(struct tty_struct *tty, const unsigned char *buf,
>  		      int len);
> -extern void line_put_char(struct tty_struct *tty, unsigned char ch);
> +extern int line_put_char(struct tty_struct *tty, unsigned char ch);
>  extern void line_set_termios(struct tty_struct *tty, struct ktermios * old);
>  extern int line_chars_in_buffer(struct tty_struct *tty);
>  extern void line_flush_buffer(struct tty_struct *tty);

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


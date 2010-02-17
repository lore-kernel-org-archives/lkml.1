Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab0BQXSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 18:18:23 -0500
Received: from kroah.org ([198.145.64.141]:33411 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757753Ab0BQXSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 18:18:18 -0500
Date: Wed, 17 Feb 2010 15:11:41 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Keep the default buffering to sub-page units
Message-ID: <20100217231141.GA4734@kroah.com>
References: <20100217130405.15830.27197.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100217130405.15830.27197.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 01:04:53PM +0000, Alan Cox wrote:
> We allocate during interrupts so while our buffering is normally diced up
> small anyway on some hardware at speed we can pressure the VM excessively
> for page pairs. We don't really need big buffers to be linear so don't try
> so hard.
> 
> In order to make this work well we will tidy up excess callers to request_room,
> which cannot itself enforce this break up.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/char/tty_buffer.c |    5 +++--
>  include/linux/tty.h       |   10 ++++++++++
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
> index 66fa4e1..8402eda 100644
> --- a/drivers/char/tty_buffer.c
> +++ b/drivers/char/tty_buffer.c
> @@ -247,7 +247,7 @@ int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars,
>  {
>  	int copied = 0;
>  	do {
> -		int space = tty_buffer_request_room(tty, size - copied);
> +		int space = tty_buffer_request_room(tty, goal);

This causes the build error:

  CC      drivers/char/tty_buffer.o
drivers/char/tty_buffer.c: In function ‘tty_insert_flip_string’:
drivers/char/tty_buffer.c:250: error: ‘goal’ undeclared (first use in this function)
drivers/char/tty_buffer.c:250: error: (Each undeclared identifier is reported only once
drivers/char/tty_buffer.c:250: error: for each function it appears in.)

So I'll drop it for now.

Care to fix this?

thanks,

greg k-h

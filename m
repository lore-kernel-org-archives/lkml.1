Return-Path: <linux-kernel-owner+w=401wt.eu-S933371AbZLOVUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbZLOVUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbZLOVUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:20:07 -0500
Received: from 1wt.eu ([62.212.114.60]:52705 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661AbZLOVUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:20:06 -0500
Date: Tue, 15 Dec 2009 22:19:53 +0100
From: Willy Tarreau <w@1wt.eu>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>, devel@driverdev.osuosl.org,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       Costantino Leandro <lcostantino@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compilation error of drivers/staging/panel/panel.c w/ custom lcd charset
Message-ID: <20091215211953.GE11857@1wt.eu>
References: <1260854505-17786-1-git-send-email-peterhuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260854505-17786-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 06:21:45AM +0100, Peter Huewe wrote:
> When compiling panel.c with a DEFAULT_LCD_CHARSET it fails to compile
> with the following error message:
> drivers/staging/panel/panel.c: In function >>lcd_init<<:
> drivers/staging/panel/panel.c:1396: error: expected expression before
> >>;<< token
> drivers/staging/panel/panel.c:1475: error: expected expression before
> >>;<< token
> make[3]: *** [drivers/staging/panel/panel.o] error 1
> make[2]: *** [drivers/staging/panel] error 2
> make[1]: *** [drivers/staging] error 2

(...)
>  #ifdef CONFIG_PANEL_LCD_CHARSET
>  #undef DEFAULT_LCD_CHARSET
> -#define DEFAULT_LCD_CHARSET
> +#define DEFAULT_LCD_CHARSET CONFIG_PANEL_LCD_CHARSET
>  #endif

Wow! I don't understand how this managed to slip through the various
tests for that long. That code is the the same in my 2.4 driver too,
so that means it has never worked for the last 5 years !

Obvious ACK from me, but please take a quick look at the place
where this define is used to ensure that any expected setting of
CONFIG_PANEL_LCD_CHARSET will not result in some other cryptic
error messages being sent to the user.

Thanks!
Willy


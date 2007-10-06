Return-Path: <linux-kernel-owner+w=401wt.eu-S1765563AbXJFVLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765563AbXJFVLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 17:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764696AbXJFVLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 17:11:32 -0400
Received: from barikada.upol.cz ([158.194.242.200]:45675 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764670AbXJFVLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 17:11:32 -0400
Date: Sat, 6 Oct 2007 23:25:38 +0200
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] Colored kernel output (run3)
Message-ID: <20071006212538.GH22435@flower.upol.cz>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0710062209530.20637@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710062209530.20637@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for dealing with my acidness in the first patch :)

But what about this one?

On Sat, Oct 06, 2007 at 10:10:01PM +0200, Jan Engelhardt wrote:
> 
> Colored kernel message output (2/2)
> 
> By popular request, this patch adds per-loglevel coloring.
> The user may set values using vt.printk_color= or by modifying
> the sysfs file in the running system.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> ---
>  arch/x86_64/kernel/early_printk.c |   11 +++++++----
>  drivers/char/Kconfig              |    4 +++-
>  drivers/char/vt.c                 |   32 ++++++++++++++++++++++++--------
>  drivers/net/netconsole.c          |    3 ++-
>  drivers/serial/8250.c             |    3 ++-
>  drivers/serial/8250_early.c       |    3 ++-
>  include/linux/console.h           |    2 +-
>  kernel/printk.c                   |   12 +++++++-----
>  8 files changed, 48 insertions(+), 22 deletions(-)

Making this amount changes and not thinking about more intelligent
coding of the functionality?

> Index: linux-2.6.23/arch/x86_64/kernel/early_printk.c
> ===================================================================
> --- linux-2.6.23.orig/arch/x86_64/kernel/early_printk.c
> +++ linux-2.6.23/arch/x86_64/kernel/early_printk.c
> @@ -20,7 +20,8 @@
>  static int max_ypos = 25, max_xpos = 80;
>  static int current_ypos = 25, current_xpos = 0;
>  
> -static void early_vga_write(struct console *con, const char *str, unsigned n)
> +static void early_vga_write(struct console *con, const char *str, unsigned n,
> +                            unsigned int loglevel)
>  {

I mean, *write() have nothing to do with loglevels. If they do
(suddenly), then why not to use a char in the *str to make it possible? I
might be wrong, but there are already macros before format strings in
printk().

And this is not `loglevel' thing any more. It's attributes, which can be
used by many other drivers/file systems/schedulers/ what ever, if
developers, like Ingo, will extend printk() output to be more nice in
subsystems they develop.

So, maybe they can be extended, and functionality implemented in the
function bodies (which will be `do { } while (0)' if config is NO), but
*NOT* by passing additional argument to the functions.
___

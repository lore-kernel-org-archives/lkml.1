Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYARCai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYARCai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYARCaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:30:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbYARCaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:30:13 -0500
Date: Thu, 17 Jan 2008 18:28:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Byron Bradley <byron.bbradley@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] ramdisk driver: make rd_size non-static
Message-Id: <20080117182851.f9177571.akpm@linux-foundation.org>
In-Reply-To: <1200621737-1458-1-git-send-email-byron.bbradley@gmail.com>
References: <1200621737-1458-1-git-send-email-byron.bbradley@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 02:02:17 +0000 Byron Bradley <byron.bbradley@gmail.com> wrote:

> In arch/arm/kernel/setup.c:setup_ramdisk(), rd_size is set from the
> boot tags. The replacement ramdisk driver has rd_size as static
> which causes linking to fail when ramdisk is built-in.
> 

but...

> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index 5ef1d26..8536480 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -385,7 +385,7 @@ static struct block_device_operations brd_fops = {
>   * And now the modules code and kernel interface.
>   */
>  static int rd_nr;
> -static int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
> +int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
>  module_param(rd_nr, int, 0);
>  MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
>  module_param(rd_size, int, 0);

rd_size is a module parameter so it is settable via the
syntax-which-i-can-never-remember.  rd.rd_size=1024 or something like that.

If that's all sane, do we have some back-compat reason to continue to
support the special and duplicative rd_size parameter?


(If we never did crap like this:

arch/arm/kernel/setup.c:        extern int rd_size, rd_image_start, rd_prompt, rd_doload;

then this sort of problem wouldn't occur so often)

MIPS has the same problem.

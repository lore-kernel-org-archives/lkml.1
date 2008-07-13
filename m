Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbYGMFLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbYGMFLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 01:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbYGMFLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 01:11:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbYGMFLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 01:11:33 -0400
Date: Sat, 12 Jul 2008 22:11:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] vt: do not update when the console is blanked
Message-Id: <20080712221120.5356df22.akpm@linux-foundation.org>
In-Reply-To: <4877732A.5030106@eu.citrix.com>
References: <4877732A.5030106@eu.citrix.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-fbdev-devel)

On Fri, 11 Jul 2008 15:50:18 +0100 Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:

> Hi all,
> vt.c DO_UPDATE macro checks if the console is visible but doesn't check if
> the console is blanked.
> In fact updating fbcon while the console is blanked is not only unnecessary
> but can even cause screen corruption.
> Therefore I am adding a simple check on console_blanked in DO_UPDATE.
> 
> Signed-off-by: stefano.stabellini@eu.citrix.com
> 
> ---
> 
> diff --git a/drivers/char/vt.c b/drivers/char/vt.c
> index 935f1c2..8d4bd3c 100644
> --- a/drivers/char/vt.c
> +++ b/drivers/char/vt.c
> @@ -261,7 +261,7 @@ static void notify_update(struct vc_data *vc)
>  #ifdef VT_BUF_VRAM_ONLY
>  #define DO_UPDATE(vc)	0
>  #else
> -#define DO_UPDATE(vc)	CON_IS_VISIBLE(vc)
> +#define DO_UPDATE(vc)	(CON_IS_VISIBLE(vc) && !console_blanked)
>  #endif
>  
>  static inline unsigned short *screenpos(struct vc_data *vc, int offset, int viewed)
> 


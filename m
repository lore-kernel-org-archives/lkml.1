Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbYAYKa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbYAYKa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYAYKaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:30:21 -0500
Received: from styx.suse.cz ([82.119.242.94]:35019 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753884AbYAYKaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:30:19 -0500
Date: Fri, 25 Jan 2008 11:30:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] linux-2.6.24/drivers/hid/hid-input.c
In-Reply-To: <20080125101134.GA3802@titan.lahn.de>
Message-ID: <Pine.LNX.4.64.0801251129160.22844@jikos.suse.cz>
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org>
 <20080125101134.GA3802@titan.lahn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008, Philipp Matthias Hahn wrote:

> In hidinput_configure_usage(device), IS_CHICONY_TACTICAL_PAD(devic) gets
> passed the 'device' parameter. But that macro still references its
> parameter by 'device' instead of by its local name 'x'.
> Signed-off-by: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
> 
> --- linux/drivers/hid/hid-input.c	2008-01-25 09:57:17.000000000 +0100
> +++ linux/drivers/hid/hid-input.c	2008-01-25 10:56:35.835871529 +0100
> @@ -87,7 +87,7 @@
>  #define map_key_clear(c)	do { map_key(c); clear_bit(c, bit); } while (0)
>  
>  /* hardware needing special handling due to colliding MSVENDOR page usages */
> -#define IS_CHICONY_TACTICAL_PAD(x) (x->vendor == 0x04f2 && device->product == 0x0418)
> +#define IS_CHICONY_TACTICAL_PAD(x) (x->vendor == 0x04f2 && x->product == 0x0418)
>  #define IS_MS_KB(x) (x->vendor == 0x045e && (x->product == 0x00db || x->product == 0x00f9))

Hi Philipp,

thanks a lot for spotting this. I have however rewritten the ugly handling 
of hid-input mapping quirks code, so this bug is not present anymore 
(please see hid-input-quirks branch of my git tree, if interested).

Thanks,

-- 
Jiri Kosina
SUSE Labs

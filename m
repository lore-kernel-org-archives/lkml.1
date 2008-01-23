Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYAWHYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYAWHYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 02:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYAWHYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 02:24:10 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:39552 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbYAWHYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 02:24:09 -0500
Date: Wed, 23 Jan 2008 08:24:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: v4l-dvb-maintainer@linuxtv.org, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] radio: fix sf16fmi section mismatch
Message-ID: <20080123072411.GA19132@uranus.ravnborg.org>
References: <20080122213939.59db650f.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122213939.59db650f.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 09:39:39PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> isapnp_fmi_probe() is only called by fmi_init(), which is __init,
> so isapnp_fmi_probe() can also be __init.
> 
> media/radio/radio-sf16fmi.c:
> WARNING: vmlinux.o(.text+0x994e19): Section mismatch: reference to .init.data: (between 'isapnp_fmi_probe' and 'vidioc_s_tuner')
> WARNING: vmlinux.o(.text+0x994e22): Section mismatch: reference to .init.data: (between 'isapnp_fmi_probe' and 'vidioc_s_tuner')
> WARNING: vmlinux.o(.text+0x994e3a): Section mismatch: reference to .init.data:id_table (between 'isapnp_fmi_probe' and 'vidioc_s_tuner')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

> ---
>  drivers/media/radio/radio-sf16fmi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.24-rc8-git5.orig/drivers/media/radio/radio-sf16fmi.c
> +++ linux-2.6.24-rc8-git5/drivers/media/radio/radio-sf16fmi.c
> @@ -321,7 +321,7 @@ static struct isapnp_device_id id_table[
>  
>  MODULE_DEVICE_TABLE(isapnp, id_table);
>  
> -static int isapnp_fmi_probe(void)
> +static int __init isapnp_fmi_probe(void)
>  {
>  	int i = 0;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

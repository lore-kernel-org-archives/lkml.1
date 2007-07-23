Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbXGWGS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbXGWGS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbXGWGSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:18:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:57257 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbXGWGSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GbZ2/373/oculHrrmhiVLJvaNWG4d4cj3O1rkXnO9YLi0vDNC+ZaWkotyUkdgU21zGMXL/0wkONSNI21rPN2I5YLMsbSwk42/En0YVWiYopt5cgCGwY+gIUYaFP8GmREF4UkekmDXIqLaq8F2xKjSGvofM8f5JA/wM6eBd+gNpA=
Subject: Re: [PATCH] Fix fbcon - 'map_override' defined but not used warning
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46A38486.70903@googlemail.com>
References: <46A38486.70903@googlemail.com>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 14:18:44 +0800
Message-Id: <1185171524.5046.2.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 18:23 +0200, Gabriel C wrote:
> Hi,
> 
> I got this warning on current git:
> 
> ...
> 
> drivers/video/console/fbcon.c:130: warning: 'map_override' defined but not used
> 
> ...
> 
> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
> 
> ---
> 
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> index decfdc8..60a14de 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -127,7 +127,9 @@ static int last_fb_vc = MAX_NR_CONSOLES - 1;
>  static int fbcon_is_default = 1; 
>  static int fbcon_has_exited;
>  static int primary_device = -1;
> +#ifndef MODULE

Disrecard my other comment. This should be

#ifdef CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY

>  static int map_override;
> +#endif
>  
>  /* font data */
>  static char fontname[40];

Tony


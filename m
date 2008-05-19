Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYESGiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYESGiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 02:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYESGim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 02:38:42 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34050 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbYESGil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 02:38:41 -0400
Date: Mon, 19 May 2008 08:39:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Cc: linux <linux-kernel@vger.kernel.org>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/1] kconfig: incorrect 'len' field initialisation ?
Message-ID: <20080519063919.GA17698@uranus.ravnborg.org>
References: <20080518211024.D1B751C00086@mwinf2714.orange.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080518211024.D1B751C00086@mwinf2714.orange.fr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 11:10:24PM +0200, Christophe Jaillet wrote:
> From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> 
> Hi, here is a patch against /scripts/kconfig/util.c :
> 	
> 1) The field 'len' of the 'gstr' structure seems to track the size of the memory 
> already allocated for the "growable string". So the value of this field should be
> the same as the 'malloc()' just above, shouldn't it ?
> 
> 
> 
> Note: this patch is based on 'linux-2.6.25.tar.bz2'
> 
> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> 
> ---
> 
> --- linux 2.6.25/scripts/kconfig/util.c	2008-04-17 04:49:44.000000000 +0200
> +++ linux 2.6.25/scripts/kconfig/util.c.cj	2008-05-18 22:56:14.000000000 +0200
> @@ -77,7 +77,7 @@ struct gstr str_new(void)
>  {
>  	struct gstr gs;
>  	gs.s = malloc(sizeof(char) * 64);
> -	gs.len = 16;
> +	gs.len = 64;
>  	strcpy(gs.s, "\0");
>  	return gs;
>  }

Thanks Christophe.
Obviously correct - I will apply to kbuild-fixes.git.

	Sam

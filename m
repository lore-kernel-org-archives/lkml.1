Return-Path: <linux-kernel-owner+w=401wt.eu-S1764905AbYASB3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764905AbYASB3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760045AbYASB3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:29:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42316 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619AbYASB3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:29:04 -0500
Date: Fri, 18 Jan 2008 17:28:07 -0800
From: Greg KH <greg@kroah.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <GregKH@novell.com>
Subject: Re: [PATCH 3/4] introduce __devinitconst
Message-ID: <20080119012807.GB6150@kroah.com>
References: <47873D110200007800068158@novell.com> <47873D87.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47873D87.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 01:57:27AM -0700, Jan Beulich wrote:
> The drivers picked just serve as examples (which I routinely build and
> hence am able to easily verify), i.e. as before he patch doesn't change
> all instances where 'const' could have been added as a result of the
> base change, only where the change has a real effect (the module loader
> doesn't enforce read-only section attributes at present, so only
> built-in files make a real difference).

What does this buy us?

> --- 2.6.24-rc7-initconst.orig/include/linux/init.h
> +++ 2.6.24-rc7-initconst/include/linux/init.h
> @@ -257,11 +257,13 @@ void __init parse_early_param(void);
>  #ifdef CONFIG_HOTPLUG
>  #define __devinit
>  #define __devinitdata
> +#define __devinitconst const
>  #define __devexit
>  #define __devexitdata
>  #else
>  #define __devinit __init
>  #define __devinitdata __initdata
> +#define __devinitconst __initdata

Shoudn't that be "__initdata const" or something like that?

thanks,

greg k-h

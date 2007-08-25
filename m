Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbXHYPYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbXHYPYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 11:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbXHYPYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 11:24:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39414 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbXHYPYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 11:24:35 -0400
Date: Sat, 25 Aug 2007 08:23:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: spock@gentoo.org, linux-fbdev-devel@lists.sourceforge.net
Cc: Michal Januszewski <spock@gentoo.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] uvesafb: select connector in
 Kconfig
Message-Id: <20070825082341.e939e38e.randy.dunlap@oracle.com>
In-Reply-To: <20070825085931.GA9318@spock.one.pl>
References: <20070825085931.GA9318@spock.one.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2007 10:59:31 +0200 Michal Januszewski wrote:

> Make uvesafb select connector instead of depending on it being already selected.
> 
> Signed-off-by: Michal Januszewski <spock@gentoo.org>
> ---
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index f1cc899..e152eed 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -594,7 +594,8 @@ config FB_TGA
>  
>  config FB_UVESA
>  	tristate "Userspace VESA VGA graphics support"
> -	depends on FB && CONNECTOR
> +	depends on FB
> +	select CONNECTOR
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT

There are 2 problems with this.

a.  CONNECTOR depends on NET, but select won't enable NET, so if
NET is not enabled otherwise, CONNECTOR still won't build.
This is a longstanding select/kconfig issue.

b.  CONNECTOR depends on NET, so if select did follow the depends
chain and enable NET, it would be enabling the networking subsystem,
which is something that should not be done quietly.

select should only be used for enabling small library-like code
(if even then).  Avoid it whenever possible.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner+w=401wt.eu-S1767241AbXDTUqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767241AbXDTUqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767246AbXDTUqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:46:43 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35466
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767241AbXDTUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:46:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 7/8] Kconfig: silicon backplane dependency.
Date: Fri, 20 Apr 2007 22:45:43 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       akpm@linux-foundation.org, linville@tuxdriver.com
References: <20070420113505.GH3738@skybase>
In-Reply-To: <20070420113505.GH3738@skybase>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704202245.43806.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007 13:35, Martin Schwidefsky wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Make the "Sonics Silicon Backplane" menu dependent on the two buses
> it can be found on.
> Goes on top of git-wireless.patch.
> 
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
> 
>  drivers/ssb/Kconfig |    1 +
>  1 files changed, 1 insertion(+)
> 
> diff -urpN linux-2.6/drivers/ssb/Kconfig linux-2.6-patched/drivers/ssb/Kconfig
> --- linux-2.6/drivers/ssb/Kconfig	2007-04-19 15:24:40.000000000 +0200
> +++ linux-2.6-patched/drivers/ssb/Kconfig	2007-04-19 15:55:44.000000000 +0200
> @@ -1,4 +1,5 @@
>  menu "Sonics Silicon Backplane"
> +	depends on PCI || PCMCIA

This is wrong. SSB does not depend on PCI or PCMCIA.
SSB can (and does) stay very well on its own feet and
can be the main system bus.
Most Linksys WRT routers work that way. They have no
PCI bus, but a SSB bus instead.

Nevertheless, I'm not sure what your problem really is.
Does a s390 machine exist with a B44 card? I doubt it.
So what about the following: We simply add
a DEPENDS ON !S390 to both SSB and B44.
I really thing that is the right fix for this.
The patch above is clearly not, as it breaks things for
embedded devices without PCI or PCMCIA bus.

-- 
Greetings Michael.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYJLWDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYJLWDr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 18:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYJLWDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 18:03:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:35280 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYJLWDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 18:03:38 -0400
Date: Sun, 12 Oct 2008 15:03:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sergio Luis <sergio@larces.uece.br>
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH] drivers/mfd/ucb1400_core.c: fix undefined reference to
 `ac97_bus_type'
Message-Id: <20081012150328.b272975c.randy.dunlap@oracle.com>
In-Reply-To: <48F22345.1040407@larces.uece.br>
References: <48F22345.1040407@larces.uece.br>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2008 13:18:13 -0300 Sergio Luis wrote:

> randconfig got a problem with ucb1400_core.c (config attached)
> 
> drivers/built-in.o:(.data+0x15ab4): undefined reference to `ac97_bus_type'
> make: *** [.tmp_vmlinux1] Error 1
> 
> ucb1400 is an ac97 audio codec. express this dependency in Kconfig
> 
> Signed-off-by: Sergio Luis <sergio@larces.uece.br>
> Cc: Marek Vasut <marek.vasut@gmail.com>
> 
> drivers/mfd/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 0dae245..fa851c5 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -52,6 +52,7 @@ config HTC_PASIC3
>  
>  config UCB1400_CORE
>  	tristate "Philips UCB1400 Core driver"
> +	select AC97_BUS
>  	help
>  	  This enables support for the Philips UCB1400 core functions.
>  	  The UCB1400 is an AC97 audio codec.

Hi,

Andrew has a "depends on AC97_BUS" patch queued and approved... fwiw.

The problem with "select AC97_BUS" is that SOUND could be =n and
selecting AC97_BUS still will not enable SOUND, so it's useless
(unless/until kconfig is taught to follow select dependencies).

---
~Randy

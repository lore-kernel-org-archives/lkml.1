Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbXFGJ0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbXFGJ0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 05:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbXFGJ00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 05:26:26 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:3030 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXFGJ0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 05:26:25 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jun 2007 05:26:24 EDT
Date: Thu, 7 Jun 2007 11:19:42 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm2
Message-ID: <20070607091942.GA1584@roarinelk.homelinux.net>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070607064231.GQ6909@holomorphy.com> <20070607071138.GA15420@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607071138.GA15420@linux-sh.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 04:11:38PM +0900, Paul Mundt wrote:
> On Wed, Jun 06, 2007 at 11:42:31PM -0700, William Lee Irwin III wrote:
> > sound/soc/sh/Kconfig:6:warning: 'select' used by config symbol 'SND_SOC_PCM_SH7760' refers to undefined symbol 'SH_DMABRG'

---

Make SND_SOC_PCM_SH7760 depend on SH_DMABRG rather than selecting it

Fixes Kconfig warning about undefined SH_DMABRG symbol on non-sh builds.


Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>


--- linux-2.6.22-rc4-mm2/sound/soc/sh/Kconfig~	2007-06-07 11:09:30.000000000 +0200
+++ linux-2.6.22-rc4-mm2/sound/soc/sh/Kconfig	2007-06-07 11:09:30.000000000 +0200
@@ -2,8 +2,7 @@ menu "SoC Audio support for SuperH"
 
 config SND_SOC_PCM_SH7760
 	tristate "SoC Audio support for Renesas SH7760"
-	depends on CPU_SUBTYPE_SH7760 && SND_SOC
-	select SH_DMABRG
+	depends on CPU_SUBTYPE_SH7760 && SND_SOC && SH_DMABRG
 	help
 	  Enable this option for SH7760 AC97/I2S audio support.
 

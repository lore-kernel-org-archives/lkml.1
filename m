Return-Path: <linux-kernel-owner+w=401wt.eu-S1759906AbYBAH71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbYBAH71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYBAH7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:59:18 -0500
Received: from mx1.suse.de ([195.135.220.2]:33001 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbYBAH7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:59:17 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SuSE Linux Products GmbH
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] nozomi: constify driver
Date: Fri, 1 Feb 2008 08:59:14 +0100
User-Agent: KMail/1.9.5
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
References: <200801312210.30722.fseidel@suse.de> <200802010725.05421.fseidel@suse.de> <20080201072815.GA5345@uranus.ravnborg.org>
In-Reply-To: <20080201072815.GA5345@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802010859.14583.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 08:28, Sam Ravnborg wrote:
> __devinitdata is for non-const data.
> __devinitconst is for const data.
>
> You cannot mix const and non-const data in the same section,
> if you do so gcc will complain.
> It may build for you if all uses of __devinitdata in the
> same source file is either const or non-const but when you
> mix it then it breaks.
> 
> So please use the correct annotation.

Ok, i see .. thanks for this explanation.
I'll repost with this fixed

BTW in this case those drivers also need to be fixed in current
git tree, should they?
drivers/edac/amd76x_edac.c
drivers/edac/e752x_edac.c
drivers/edac/e7xxx_edac.c
drivers/edac/i3000_edac.c
drivers/edac/i5000_edac.c
drivers/edac/i82443bxgx_edac.c
drivers/edac/i82860_edac.c
drivers/edac/i82875p_edac.c
drivers/edac/i82975x_edac.c
drivers/edac/r82600_edac.c
drivers/macintosh/macio_asic.c
drivers/mmc/host/ricoh_mmc.c
drivers/mmc/host/sdhci.c
drivers/net/natsemi.c
drivers/net/via-velocity.c
drivers/scsi/aic94xx/aic94xx_init.c

> We do small incremental steps whenever we can. The challenge is
> often to split up patches and not to combine them.
> 
> Where we combine two patches this is when the second patch fix
> a bug in the first patch.

To me it felt like those changes are so trivial and kind of
belong together so that i thought it would be ok here. But
i'll repost it as two patches in a few moments.

Thanks,
Frank

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0BARIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:08:06 -0500
Received: from mail.perches.com ([173.55.12.10]:1688 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab0BARIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:08:04 -0500
Subject: Re: [PATCH 10/10] sound/soc/blackfin: Fix continuation line formats
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
In-Reply-To: <20100201144745.GC26011@rakim.wolfsonmicro.main>
References: <cover.1264967493.git.joe@perches.com>
	 <aee58f4fc07709fe8a34021899e701824a0a6b53.1264967500.git.joe@perches.com>
	 <20100201144745.GC26011@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 09:08:00 -0800
Message-ID: <1265044080.25140.266.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 14:47 +0000, Mark Brown wrote:
> On Sun, Jan 31, 2010 at 12:02:12PM -0800, Joe Perches wrote:
> > String constants that are continued on subsequent lines with \
> > are not good.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Gah, I thought I'd caught most of these when reviewing.  If you're using
> a script to pick this stuff up it'd be worth checking for extraneous
> continuations in the middle of code - outside of macros there's little
> call for it.
> 
> Applied, thanks.

There are a few false positives and probably a few missing using

        grep -rP --include=*.[ch] '".*\\$' * | \
        awk '{ if ((gsub("\"", "\"") % 2) == 1) print $0; }'
        
Most of the uses are __asm__ __volatile__ which could be
considered unsightly but don't impact logging messages.

The rest could/should be fixed.



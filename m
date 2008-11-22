Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbYKVBje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbYKVBje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbYKVBjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:39:21 -0500
Received: from mga12.intel.com ([143.182.124.36]:32357 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758104AbYKVBjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:39:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,648,1220252400"; 
   d="scan'208";a="80462967"
Date: Sat, 22 Nov 2008 09:39:02 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH linux-next] snd-hda: fix build errors
Message-ID: <20081122013902.GA12810@localhost>
References: <20081121181948.ee771502.sfr@canb.auug.org.au> <492713E8.9080103@oracle.com> <s5hy6zc7rjr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hy6zc7rjr.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 09:27:52PM +0100, Takashi Iwai wrote:
> At Fri, 21 Nov 2008 12:02:48 -0800,
> Randy Dunlap wrote:
> > 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > First error comes from snd_hda_eld_proc_new() not being static
> > when CONFIG_PROC_FS=n.  After that is fixed, the next problem is:
> > ERROR: "snd_print_pcm_rates" [sound/pci/hda/snd-hda-intel.ko] undefined!
> > 
> > so I made a static inline version of that one too, for CONFIG_PROC_FS=n.
> > Please build/test more config variations.
> > 
> >   LD [M]  sound/pci/hda/snd-hda-intel.o
> > sound/pci/hda/hda_eld.o: In function `snd_hda_eld_proc_new':
> > (.text+0x0): multiple definition of `snd_hda_eld_proc_new'
> > sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
> > sound/pci/hda/hda_hwdep.o: In function `snd_hda_eld_proc_new':
[...]
> > sound/pci/hda/patch_intelhdmi.o: In function `snd_hda_eld_proc_new':
> > (.text+0x3b): multiple definition of `snd_hda_eld_proc_new'
> > sound/pci/hda/hda_codec.o:(.text+0x58): first defined here
> > make[4]: *** [sound/pci/hda/snd-hda-intel.o] Error 1
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > cc: Wu Fengguang <wfg@linux.intel.com>
> > cc: Takashi Iwai <tiwai@suse.de>
> > ---
> >  sound/pci/hda/hda_local.h |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Thanks, but these have been differently fixed on the latest ALSA tree.
> snd_print_pcm_*() have to be defined no matter what CONFIG_PROC_FS is.

Thank you!

I'll send another fix for remaining build warnings when CONFIG_PROC_FS=n.

Fengguang

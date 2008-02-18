Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYBRHpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYBRHpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYBRHpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:45:00 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:41943 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbYBRHpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:45:00 -0500
Date: Mon, 18 Feb 2008 08:45:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH 27/27] [ALSA] hdsp - fix section mismatch warnings
Message-ID: <20080218074508.GA19603@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org> <1203250984-11285-27-git-send-email-sam@ravnborg.org> <s5hr6favk6j.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hr6favk6j.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 07:43:32AM +0100, Takashi Iwai wrote:
> At Sun, 17 Feb 2008 13:23:04 +0100,
> Sam Ravnborg wrote:
> > 
> > Fix following warnings:
> > WARNING: sound/pci/rme9652/snd-hdsp.o(.text+0x34bc): Section mismatch in reference from the function hdsp_check_for_firmware() to the function .devinit.text:hdsp_request_fw_loader()
> > WARNING: sound/pci/rme9652/snd-hdsp.o(.text+0x4ac6): Section mismatch in reference from the function snd_hdsp_proc_read() to the function .devinit.text:hdsp_request_fw_loader()
> > 
> > Calling hdsp_request_fw_loader() were triggered from /proc
> > so this is not restricted to init or hotplug.
> > So removing the __devexit annotation of this function
> > and one of the functions fix the warning.
> 
> Thanks.  The exactly same fix has been already on ALSA tree since
> weeks ago, but was never pushed...

OK, I assume this will be pushed soonish so we can kill
another warning.

	Sam

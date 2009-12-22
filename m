Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZLVTjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZLVTjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZLVTjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:39:07 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59445 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbZLVTjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:39:05 -0500
X-Sasl-enc: uh7xNZflve85gEQIn4Ib9x08tlUUd6u6Onl8f564MI1J 1261510740
Date: Tue, 22 Dec 2009 17:38:58 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Marcel Holtmann <marcel@holtmann.org>, Takashi Iwai <tiwai@suse.de>,
       Xiaotian Feng <xtfeng@gmail.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>,
       ibm-acpi-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, akpm@linux-foundation.org,
       helight.xu@gmail.com
Subject: Re: [Patch] thinkpad_acpi: fix a build error
Message-ID: <20091222193858.GB1796@khazad-dum.debian.net>
References: <20091218093132.4415.23424.sendpatchset@localhost.localdomain>
 <7b6bb4a50912180142u5e66fa88odb7cd3b6fa1a2ba2@mail.gmail.com>
 <s5hhbrowpty.wl%tiwai@suse.de>
 <20091218142815.GB15898@khazad-dum.debian.net>
 <1261435136.4041.152.camel@localhost.localdomain>
 <20091221144432.81702725.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221144432.81702725.rdunlap@xenotime.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009, Randy Dunlap wrote:
> On Mon, 21 Dec 2009 14:38:56 -0800 Marcel Holtmann wrote:
> > > > The patch isn't correct (I guess the upstream fix is same?).
> > > > 
> > > > CONFIG_SOUND is a global config for sound subsystem.  The relevant
> > > > functions are ALSA core part, which is CONFIG_SND.
> > > > So, the fix should be:
> > > > 
> > > > 	depends on SND
> > > > 
> > > > instead.
> > > 
> > > Indeed.  Ingo already fixed that too.
> > > 
> > > Although I personally would prefer:
> > > select SOUND
> > > select SND
> > > 
> > > But anything that stops the build errors will do for now.
> > 
> > I still haven't seen this patch in Linus' tree. And you do need select
> > SOUND and SND. Otherwise you still get build errors. I have tested this
> > on my machine. So can someone please submit a proper patch to get this
> > fixed.
> 
> Ugh.  Please don't 'select' to build an entire subsystem.

I won't in this case. I think I will cook up a patch to disable the entire
mixer subsystem in thinkpad-acpi if CONFIG_SND is not available.  I don't
like the depends on SND though.

As for select an entire subsystem, sorry, but I already do that for stuff
like input and backlight.  Depends is a real CRAP for the user interface in
the case of platform drivers like thinkpad-acpi.

If we could get a depends-no-hide thing, that would not cause drivers to
simply disappear from the config interface without a trace, then maybe I
would have no reason for selects.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

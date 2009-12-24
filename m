Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbZLXS7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbZLXS7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 13:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZLXS7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 13:59:18 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47611 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003AbZLXS7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 13:59:18 -0500
X-Sasl-enc: 5RqBsYxse40ekSv5KV5u9rMlWLFeRnncTGyYiyYxfnro 1261681156
Date: Thu, 24 Dec 2009 16:59:12 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Takashi Iwai <tiwai@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Marcel Holtmann <marcel@holtmann.org>,
       Xiaotian Feng <xtfeng@gmail.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>,
       ibm-acpi-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, akpm@linux-foundation.org,
       helight.xu@gmail.com
Subject: Re: [Patch] thinkpad_acpi: fix a build error
Message-ID: <20091224185912.GA25861@khazad-dum.debian.net>
References: <20091218093132.4415.23424.sendpatchset@localhost.localdomain>
 <7b6bb4a50912180142u5e66fa88odb7cd3b6fa1a2ba2@mail.gmail.com>
 <s5hhbrowpty.wl%tiwai@suse.de>
 <20091218142815.GB15898@khazad-dum.debian.net>
 <1261435136.4041.152.camel@localhost.localdomain>
 <20091221144432.81702725.rdunlap@xenotime.net>
 <20091222193858.GB1796@khazad-dum.debian.net>
 <s5hhbrimbtw.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhbrimbtw.wl%tiwai@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Dec 2009, Takashi Iwai wrote:
> At Tue, 22 Dec 2009 17:38:58 -0200,
> Henrique de Moraes Holschuh wrote:
> > I won't in this case. I think I will cook up a patch to disable the entire
> > mixer subsystem in thinkpad-acpi if CONFIG_SND is not available.  I don't
> > like the depends on SND though.
> 
> That's also not so trivial unless you give any dependency in Kconfig.
> Without a restriction, THINKPAD_ACPI=y and SND=m can be chosen.

"depends on SND || SND = n" takes care of the technical restrictions.

I am testing the patch now.  No ALSA, no volume subdriver, module still
works (and prints some crap to syslog so that the user knows the driver
could do more with ALSA support).

> It'd be also not nice if suddenly a certain functionality disappears
> without warning (even if the subsystem is enabled but as a module).

The warning will be there.  Although I don't warn of missing rfkill
functionality if the kernel is missing the rfkill subsystem...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

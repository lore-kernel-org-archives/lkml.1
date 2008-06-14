Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbYFNAOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbYFNAOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbYFNAMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:12:37 -0400
Received: from mail.suse.de ([195.135.220.2]:34101 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760079AbYFNAMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:12:36 -0400
Date: Fri, 13 Jun 2008 17:10:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 06/47] ALSA: hda - Fix resume of auto-config mode with
	Realtek codecs
Message-ID: <20080614001028.GF24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-fix-resume-of-auto-config-mode-with-realtek-codecs.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Takashi Iwai <tiwai@suse.de>

upstream commit: 07bc76dfa19b10017b518dd9aa1b2719e8c863de

The auto-config mode of Realtek ALC codecs has a bug since 2.6.25
that it cannot resume properly.  The problem was the wrong assignment
of init_hook that overrides the whole initialization.

Relevant bug reports:
	http://bugzilla.kernel.org/show_bug.cgi?id=10662
	https://bugzilla.novell.com/show_bug.cgi?id=385473

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -940,7 +940,6 @@ do_sku:
 			    AC_VERB_SET_UNSOLICITED_ENABLE,
 			    AC_USRSP_EN | ALC880_HP_EVENT);
 	spec->unsol_event = alc_sku_unsol_event;
-	spec->init_hook = alc_sku_automute;	
 }
 
 /*

-- 

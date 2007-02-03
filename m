Return-Path: <linux-kernel-owner+w=401wt.eu-S1946243AbXBCCxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946243AbXBCCxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946257AbXBCCwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:52:49 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52804 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946243AbXBCCg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:36:58 -0500
Message-Id: <20070203024109.375084000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:26 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>
Subject: [patch 22/59] ALSA hda-codec - Fix NULL dereference in generic hda code
Content-Disposition: inline; filename=alsa-hda-codec-fix-null-dereference-in-generic-hda-code.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Takashi Iwai <tiwai@suse.de>

Fix NULL dereference in hda_generic.c.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
commit 6afeb11de5b28e47adea1459c35e598bb98424d6
tree 07f4dba0e2fb094b448eb9863de7b6364b768add
parent f9cc8a8b1887e6e2bb430405d0a4f9b5fb39fa5d
author Takashi Iwai <tiwai@suse.de> Mon, 18 Dec 2006 16:16:04 +0100
committer Jaroslav Kysela <perex@suse.cz> Tue, 09 Jan 2007 09:06:17 +0100

 sound/pci/hda/hda_generic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.19.2.orig/sound/pci/hda/hda_generic.c
+++ linux-2.6.19.2/sound/pci/hda/hda_generic.c
@@ -485,8 +485,9 @@ static const char *get_input_type(struct
 			return "Front Aux";
 		return "Aux";
 	case AC_JACK_MIC_IN:
-		if (node->pin_caps &
-		    (AC_PINCAP_VREF_80 << AC_PINCAP_VREF_SHIFT))
+		if (pinctl &&
+		    (node->pin_caps &
+		     (AC_PINCAP_VREF_80 << AC_PINCAP_VREF_SHIFT)))
 			*pinctl |= AC_PINCTL_VREF_80;
 		if ((location & 0x0f) == AC_JACK_LOC_FRONT)
 			return "Front Mic";

--

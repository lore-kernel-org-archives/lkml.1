Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZG1Xth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZG1Xth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbZG1Xtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:35 -0400
Received: from kroah.org ([198.145.64.141]:35623 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbZG1Xte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:51 2009
Message-Id: <20090728234151.732830684@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 03/71] sound: virtuoso: fix Xonar D1/DX silence after resume
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=sound-virtuoso-fix-xonar-d1-dx-silence-after-resume.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 826390796d09444b93e1f957582f8970ddfd9b3d upstream.

When resuming, we better take the DACs out of the reset state before
trying to use them.

Reference: kernel bug #13599
	http://bugzilla.kernel.org/show_bug.cgi?id=13599

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/virtuoso.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -621,6 +621,8 @@ static void xonar_d2_resume(struct oxyge
 
 static void xonar_d1_resume(struct oxygen *chip)
 {
+	oxygen_set_bits8(chip, OXYGEN_FUNCTION, OXYGEN_FUNCTION_RESET_CODEC);
+	msleep(1);
 	cs43xx_init(chip);
 	xonar_enable_output(chip);
 }



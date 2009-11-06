Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbZKFW1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbZKFW1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbZKFWXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:34 -0500
Received: from kroah.org ([198.145.64.141]:57081 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512AbZKFWX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:27 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:49 2009
Message-Id: <20091106221549.324518938@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Henningsson <launchpad.web@epost.diwic.se>,
       Takashi Iwai <tiwai@suse.de>
Subject: [76/99] ALSA: ice1724 - Make call to set hw params succeed on ESI Juli@
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=alsa-ice1724-make-call-to-set-hw-params-succeed-on-esi-juli.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Henningsson <launchpad.web@epost.diwic.se>

commit bd3c200e6d5495343c91db66d2acf1853b57a141 upstream.

If two streams are started immediately after one another (such as a
playback and a recording stream), the call to set hw params fails with
EBUSY. This patch makes the call succeed, so playback and recording will
work properly.

Signed-off-by: David Henningsson <launchpad.web@epost.diwic.se>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ice1712/ice1724.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -643,7 +643,7 @@ static int snd_vt1724_set_pro_rate(struc
 	    (inb(ICEMT1724(ice, DMA_PAUSE)) & DMA_PAUSES)) {
 		/* running? we cannot change the rate now... */
 		spin_unlock_irqrestore(&ice->reg_lock, flags);
-		return -EBUSY;
+		return ((rate == ice->cur_rate) && !force) ? 0 : -EBUSY;
 	}
 	if (!force && is_pro_rate_locked(ice)) {
 		spin_unlock_irqrestore(&ice->reg_lock, flags);


